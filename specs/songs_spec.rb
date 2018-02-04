require('minitest/autorun')
require('minitest/rg')

require_relative('../songs.rb')

class TestSongs < MiniTest::Test

  def setup
    @song1 = Song.new({title: "Witchita Lineman", genre: "Country"})
  end

  def test_get_song_title
    assert_equal("Witchita Lineman", @song1.title)
  end

  def test_get_song_genre
    assert_equal("Country", @song1.genre)
  end

end
