require_relative './repository'
require_relative '../../domain/product'

class ProductRepository < Repository
  TABLE_NAME = "products"

  def create(product)
    client.prepare("INSERT INTO #{TABLE_NAME} (id, price, amount) VALUES (?, ?, ?)")
          .execute(product.id, product.price, product.amount)
  end

  def find_by_id(id)
    result = client.prepare("SELECT * FROM #{TABLE_NAME} WHERE id = ?")
                   .execute(id)
                   .first
    Product.new(result['id'], result['price'], result['amount'])
  end

  def lock(id)
    result = client.prepare("SELECT * FROM #{TABLE_NAME} WHERE id = ? FOR UPDATE")
                   .execute(id)
                   .first
    Product.new(result['id'], result['price'], result['amount'])
  end

  def save(product)
    client.prepare("UPDATE #{TABLE_NAME} SET amount = ? WHERE id = ?")
          .execute(product.amount, product.id)
  end
end
