class Room

  attr_reader :room_name, :checked_guests, :song_playlist, :capacity, :hire_cost, :room_bar_tab, :guests_total_cash
  attr_writer :checked_guests, :song_playlist, :room_bar_tab, :guests_total_cash

  def initialize(room)
    @room_name = room[:room_name]
    @capacity = room[:capacity]
    @hire_cost = room[:hire_cost]
    @checked_guests = []
    @song_playlist = []
    @room_bar_tab = 0
    @guests_total_cash = 0
  end

  def space_in_room()
    @checked_guests.length < @capacity
  end

  def sufficient_funds(guest)
    guest.wallet > @hire_cost
  end

  def charge_guest_for_room(guest)
    guest.wallet -= @hire_cost
  end


  def add_guest(guest)
    if space_in_room() && sufficient_funds(guest)
      @checked_guests << guest
      # charge_guest_for_room(guest)
      check_for_favourite_song(guest)
    else
      return "The room is already full."
    end
  end

#private
##Don't want anyone sneeking out without paying

  def remove_guest(name)
    @checked_guests.delete(name)
  end

#public

  def add_song(title)
    @song_playlist << title
  end

  def remove_song(title)
    @song_playlist.delete(title)
  end

  # def check_for_favourite_song(guest)
  #   @song_playlist.has_value?(guest.favourite_song)do |song|
  #   return "Whoo! That's my jam!"}
  # end
  #   return
  # end

  def check_for_favourite_song(guest)
    @song_playlist.each{|song| return "Whoo! That's my jam!" if song.title == guest.favourite_song}
    return
  end

  def add_drink_to_room_bar_tab(drink)
    @room_bar_tab += drink.price
  end

# Everyone is splitting the cost of the night because nobody wants to be that guy, right?

  def total_bill
    (@hire_cost + @room_bar_tab).round(2)
  end

  def calculate_collective_funds
   @checked_guests.sum {|guest| guest.wallet }
  end

  def check_guests_have_sufficient_collective_funds
    calculate_collective_funds - total_bill >= 0
  end

  def split_the_bill
    split = (total_bill / checked_guests.count).ceil(2)
  end

  def guest_short_for_their_share
    short = []
    for guest in @checked_guests
      short << guest if split_the_bill > guest.wallet
    end
    return short
  end

#split this functionality up with the guests.rb

  def charge_guests_bill_share
    for guest in @checked_guests
      guest.wallet = guest.wallet - split_the_bill
    end
  end

  def calculate_overpayment
    ((split_the_bill * checked_guests.count) - total_bill).round(2)
  end

  def report_change_conundrum
    return "You will have to split the £#{calculate_overpayment} change between the #{checked_guests.count} of you."
  end


  def fully_check_guest_out(customer)
    p "The total bill is £#{total_bill}. Split between #{checked_guests.count} is £#{split_the_bill} each."
    p report_change_conundrum if calculate_overpayment.round(2) > 0
    if guest_short_for_their_share.count > 0
      for guest in guest_short_for_their_share
        p "Short of a loan from another customer, #{guest} is washing glasses for the rest of the night."
      end
    end
    charge_guests_bill_share
    remove_guest(customer)
  end

end
