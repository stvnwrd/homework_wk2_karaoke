class Song

  attr_reader :title, :genre

  def initialize(song)
    @title = song[:title]
    @genre = song[:genre]
  end

end
