require('minitest/autorun')
require('minitest/rg')

require_relative('../rooms.rb')
require_relative('../guests.rb')
require_relative('../songs.rb')
require_relative('../bar.rb')


class TestRooms < MiniTest::Test

  def setup
    @room1 = Room.new({room_name: "Room 1", hire_cost: 10, capacity: 6})
    @room2 = Room.new({room_name: "Room 2", hire_cost: 20, capacity: 12})
    @room3 = Room.new({room_name: "Room 3", hire_cost: 5, capacity: 2})
    @guest1 = Guest.new({name: "Wee Gary", wallet: 50, favourite_song: "I Will Always Love You"})
    @guest2 = Guest.new({name: "Big Barry", wallet: 15, favourite_song: "Witchita Lineman"})
    @guest3 = Guest.new({name: "Vera", wallet: 100, favourite_song: "4'33"})
    @song1 = Song.new({title: "Witchita Lineman", genre: "Country"})
    @song2 = Song.new({title: "I Will Survive", genre: "Disco"})
    @song3 = Song.new({title: "4'33", genre: "Intimidation"})
    @drink1 = Drink.new({type: "Beer", price: 4.00})
    @drink2 = Drink.new({type: "Wine", price: 6.00})
    @drink3 = Drink.new({type: "Vodka", price: 5.00})

  end

  def test_get_room_name
    assert_equal("Room 1", @room1.room_name)
  end

  def test_get_room_capacity
    assert_equal(6, @room1.capacity)
  end

  def test_get_room_hire_cost
    assert_equal(10, @room1.hire_cost)
  end

  def test_get_empty_guest_list
    assert_equal([], @room1.checked_guests)
  end

  def test_check_in_guest
    @room1.add_guest(@guest1)
    assert_equal("Wee Gary", @room1.checked_guests[0].name)
  end

  def test_check_in_guest__room_already_full
    @room3.add_guest(@guest1)
    @room3.add_guest(@guest2)
    @room3.add_guest(@guest1)
    assert_equal(2, @room3.checked_guests.count)
    assert_equal("The room is already full.", @room3.add_guest(@guest3))
  end

  def test_space_in_room__true
    @room1.add_guest(@guest1)
    @room1.add_guest(@guest2)
    assert_equal(true, @room1.space_in_room)
  end

  def test_space_in_room__false
    @room1.add_guest(@guest1)
    @room1.add_guest(@guest3)
    @room1.add_guest(@guest1)
    @room1.add_guest(@guest3)
    @room1.add_guest(@guest1)
    @room1.add_guest(@guest3)
    assert_equal(false, @room1.space_in_room)
  end

  def test_sufficient_funds_for_room__true
    result = @room1.sufficient_funds(@guest3)
    assert_equal(true, result)
  end

  def test_sufficient_funds_for_room__false
    result = @room2.sufficient_funds(@guest2)
    assert_equal(false, result)
  end

  def test_charge_guest_for_room
    @room2.charge_guest_for_room(@guest3)
    assert_equal(80, @guest3.wallet)
  end

  def test_guest_checked_out
    @room1.add_guest(@guest1)
    @room1.add_guest(@guest2)
    @room1.remove_guest(@guest1)
    assert_equal("Big Barry", @room1.checked_guests[0].name)
  end


  def test_add_song_to_room
    @room1.add_song(@song1)
    assert_equal("Witchita Lineman", @room1.song_playlist[0].title)
  end

  def test_remove_song_from_room
    @room1.add_song(@song1)
    @room1.add_song(@song2)
    @room1.remove_song(@song1)
    assert_equal("I Will Survive", @room1.song_playlist[0].title)
  end

  def test_check_for_favourite_song__positive
    @room1.add_song(@song2)
    @room1.add_song(@song3)
    @room1.add_song(@song1)
    @room1.add_guest(@guest2)
    assert_equal("Whoo! That's my jam!", @room1.check_for_favourite_song(@guest2))
  end

  def test_check_for_favourite_song__negative
    @room1.add_song(@song1)
    @room1.add_song(@song2)
    @room1.add_song(@song3)
    assert_nil(@room1.check_for_favourite_song(@guest1))
  end

  def test_room_bar_tab_default
    assert_equal(0, @room1.room_bar_tab)
  end

  def test_add_drinks_to_room_bar_tab
    @room1.add_drink_to_room_bar_tab(@drink1)
    @room1.add_drink_to_room_bar_tab(@drink2)
    @room1.add_drink_to_room_bar_tab(@drink3)
    assert_equal(15, @room1.room_bar_tab)
  end

  def test_total_bill_for_room
    @room1.add_drink_to_room_bar_tab(@drink1)
    @room1.add_drink_to_room_bar_tab(@drink2)
    @room1.add_drink_to_room_bar_tab(@drink3)
    assert_equal(25, @room1.total_bill)
  end

  def test_calculate_collective_funds
    @room1.add_guest(@guest1)
    @room1.add_guest(@guest2)
    assert_equal(65, @room1.calculate_collective_funds)
  end

  def test_check_guests_have_sufficient_collective_funds__true
    @room1.add_guest(@guest1)
    @room1.add_guest(@guest2)
    @room1.add_guest(@guest3)
    @room1.add_drink_to_room_bar_tab(@drink1)
    @room1.add_drink_to_room_bar_tab(@drink2)
    @room1.add_drink_to_room_bar_tab(@drink3)
    assert_equal(true, @room1.check_guests_have_sufficient_collective_funds)
  end

  def test_check_guests_have_sufficient_collective_funds__false
    @room2.add_guest(@guest1)
    @room2.add_guest(@guest2)
    @room2.add_drink_to_room_bar_tab(@drink2)
    @room2.add_drink_to_room_bar_tab(@drink2)
    @room2.add_drink_to_room_bar_tab(@drink2)
    @room2.add_drink_to_room_bar_tab(@drink2)
    @room2.add_drink_to_room_bar_tab(@drink2)
    @room2.add_drink_to_room_bar_tab(@drink2)
    assert_equal(false, @room1.check_guests_have_sufficient_collective_funds)
  end

  def test_split_the_bill
    @room1.add_guest(@guest1)
    @room1.add_guest(@guest2)
    @room1.add_guest(@guest3)
    @room1.add_drink_to_room_bar_tab(@drink1)
    @room1.add_drink_to_room_bar_tab(@drink2)
    @room1.add_drink_to_room_bar_tab(@drink3)
    assert_equal(8.34, @room1.split_the_bill)
  end

  def test_return_each_guest_short_for_their_share
    @room1.add_guest(@guest1)
    @room1.add_guest(@guest2)
    @room1.add_drink_to_room_bar_tab(@drink2)
    @room1.add_drink_to_room_bar_tab(@drink2)
    @room1.add_drink_to_room_bar_tab(@drink2)
    @room1.add_drink_to_room_bar_tab(@drink2)
    @room1.add_drink_to_room_bar_tab(@drink2)
    assert_equal(1, @room1.guest_short_for_their_share.count)
  end

  def test_charge_guests_bill_share
    @room1.add_guest(@guest1)
    @room1.add_guest(@guest2)
    @room1.add_guest(@guest3)
    @room1.add_drink_to_room_bar_tab(@drink1)
    @room1.add_drink_to_room_bar_tab(@drink2)
    @room1.add_drink_to_room_bar_tab(@drink3)
    @room1.charge_guests_bill_share
    assert_equal(41.66, @guest1.wallet)
  end

  def test_calculate_over_payment
    @room1.add_guest(@guest1)
    @room1.add_guest(@guest2)
    @room1.add_guest(@guest3)
    @room1.add_drink_to_room_bar_tab(@drink1)
    @room1.add_drink_to_room_bar_tab(@drink2)
    @room1.add_drink_to_room_bar_tab(@drink3)
    assert_equal(0.02, @room1.calculate_overpayment)
  end

  def test_report_change_conundrum
    @room1.add_guest(@guest1)
    @room1.add_guest(@guest2)
    @room1.add_guest(@guest3)
    @room1.add_drink_to_room_bar_tab(@drink1)
    @room1.add_drink_to_room_bar_tab(@drink2)
    @room1.add_drink_to_room_bar_tab(@drink3)
    assert_equal("You will have to split the £0.02 change between the 3 of you.", @room1.report_change_conundrum)
  end

  def test_fully_check_guest_out
    @room1.add_guest(@guest1)
    @room1.add_guest(@guest2)
    @room1.add_guest(@guest3)
    @room1.add_drink_to_room_bar_tab(@drink1)
    @room1.add_drink_to_room_bar_tab(@drink2)
    @room1.add_drink_to_room_bar_tab(@drink3)
    @room1.fully_check_guest_out(@guest1)
    assert_equal(41.66, @guest1.wallet)
    assert_equal(2, @room1.checked_guests.count)
  end



end
