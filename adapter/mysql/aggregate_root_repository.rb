require_relative './repository'

class AggregateRootRepository < Repository

  def purchase_product(user_id, product_id, count)
    transaction
    result = client.prepare("SELECT * FROM users WHERE id = ? FOR UPDATE")
                 .execute(user_id)
                 .first
    user = User.new(result['id'], result['points'])
    result = client.prepare("SELECT * FROM products WHERE id = ? FOR UPDATE")
                    .execute(product_id)
                    .first
    product = Product.new(result['id'], result['price'], result['amount'])

    is_pass = yield(user, product, count)
    return unless is_pass

    client.prepare("INSERT INTO orders (user_id, product_id, count) VALUES (?, ?, ?)")
          .execute(user.id, product.id, count)
    total = product.price * count
    client.prepare("UPDATE users SET points = ? WHERE id = ?")
          .execute(user.points - total, user.id)
    client.prepare("UPDATE products SET amount = ? WHERE id = ?")
          .execute(product.amount - count, product.id)

    commit
  end
end
