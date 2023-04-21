class Order
  def initialize(user, product, count)
    self.user = user
    self.product = product
    self.count = count
  end

  attr_accessor :user, :product, :count
end
