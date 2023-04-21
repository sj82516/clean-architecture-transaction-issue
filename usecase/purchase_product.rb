class PurchaseProduct
  def initialize(user_repository, product_repository, order_repository)
    self.user_repository = user_repository
    self.product_repository = product_repository
    self.order_repository = order_repository
  end

  attr_accessor :user_repository, :product_repository, :order_repository

  def run(user_id, product_title, count)
    user_repository.transaction()
    user = user_repository.lock(user_id)
    product = product_repository.lock(product_title)
    total = product.price * count
    return unless user.can_purchase?(total)
    return unless product.can_purchase?(count)

    # to test race condition
    sleep 1

    user.points -= total
    product.amount -= count

    order = Order.new(user, product, count)
    user_repository.save(user)
    product_repository.save(product)
    order_repository.create(order)
    user_repository.commit()
  end
end
