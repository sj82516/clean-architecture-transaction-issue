require_relative './repository'
require_relative '../../domain/order'

class OrderRepository < Repository
  TABLE_NAME = "orders"

  def create(order)
    client.prepare("INSERT INTO #{TABLE_NAME} (user_id, product_id, count) VALUES (?, ?, ?)")
          .execute(order.user.id, order.product.id, order.count)
  end

  def find_by_user_id(user_id)
    result = client.prepare("SELECT * FROM #{TABLE_NAME} WHERE user_id = ?")
                   .execute(user_id)
    result.map do |row|
      Order.new(row['user_id'], row['product_id'], row['count'])
    end
  end
end
