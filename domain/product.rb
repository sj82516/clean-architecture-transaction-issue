class Product
  def initialize(id, price, amount)
    self.id = id
    self.price = price
    self.amount = amount
  end

  attr_accessor :id, :price, :amount

  def can_purchase?(count)
    amount >= count
  end
end
