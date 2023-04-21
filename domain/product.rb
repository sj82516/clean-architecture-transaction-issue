class Product
  def initialize(id, price, stock)
    self.id = id
    self.price = price
    self.stock = stock
  end

  attr_accessor :id, :price, :stock

  def can_purchase?(count)
    stock >= count
  end
end
