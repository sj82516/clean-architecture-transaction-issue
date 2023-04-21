class PurchaseProduct
  def initialize(user_repository, product_repository, order_repository, aggregate_root_repository)
    self.user_repository = user_repository
    self.product_repository = product_repository
    self.order_repository = order_repository
    self.aggregate_root_repository = aggregate_root_repository
  end

  attr_accessor :user_repository, :product_repository, :order_repository, :aggregate_root_repository

  def run(user_id, product_id, count)
    user_repository.transaction()
    user = user_repository.find_by_id_with_lock(user_id)
    product = product_repository.find_by_id_with_lock(product_id)
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

  def run_in_repo(user_id, product_id, count)
    aggregate_root_repository.purchase_product(user_id, product_id, count) do |user, product|
      total = product.price * count
      next false unless user.can_purchase?(total)
      next false unless product.can_purchase?(count)
      true
    end
  end
end
