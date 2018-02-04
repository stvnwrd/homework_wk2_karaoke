class Drink

  attr_reader :type, :price

  def initialize(drink)
    @type = drink[:type]
    @price = drink[:price]
  end

end
