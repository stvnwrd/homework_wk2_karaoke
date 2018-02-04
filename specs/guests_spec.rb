require('minitest/autorun')
require('minitest/rg')

require_relative('../guests.rb')
require_relative('../songs.rb')
# require_relative('../rooms.rb')

class TestGuests < MiniTest::Test

  def setup
    @guest1 = Guest.new({name: "Wee Gary", wallet: 50, favourite_song: "I Will Always Love You", bar_tab: 0})
  end

  def test_get_guest_name
    assert_equal("Wee Gary", @guest1.name)
  end

  def test_get_wallet_amount
    assert_equal(50, @guest1.wallet)
  end

  def test_favourite_song
    assert_equal("I Will Always Love You", @guest1.favourite_song)
  end


end
