require('minitest/autorun')
require('minitest/rg')

require_relative('../bar.rb')
require_relative('../rooms.rb')
require_relative('../guests.rb')


class TestBar < MiniTest::Test

  def setup
    @drink1 = Drink.new({type: "Beer", price: 4})
    @drink2 = Drink.new({type: "Wine", price: 5})
    @drink3 = Drink.new({type: "Vodka", price: 4.5})
  end

  def test_get_drink_type
    assert_equal("Beer", @drink1.type)
  end

  def test_get_drink_price
    assert_equal(4.5, @drink3.price)
  end

end
