class Guest

  attr_reader :name, :wallet, :favourite_song
  attr_writer :wallet


  def initialize(guest)
    @name = guest[:name]
    @wallet = guest[:wallet]
    @favourite_song = guest[:favourite_song]
  end

end
