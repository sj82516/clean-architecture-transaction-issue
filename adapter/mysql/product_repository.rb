require_relative './repository'
require_relative '../../domain/product'

class ProductRepository < Repository
  TABLE_NAME = "products"

  def create(product)
    client.prepare("INSERT INTO #{TABLE_NAME} (id, price, stock) VALUES (?, ?, ?)")
          .execute(product.id, product.price, product.stock)
  end

  def find_by_id(id)
    result = client.prepare("SELECT * FROM #{TABLE_NAME} WHERE id = ?")
                   .execute(id)
                   .first
    Product.new(result['id'], result['price'], result['stock'])
  end

  def find_by_id_with_lock(id)
    result = client.prepare("SELECT * FROM #{TABLE_NAME} WHERE id = ? FOR UPDATE")
                   .execute(id)
                   .first
    Product.new(result['id'], result['price'], result['stock'])
  end

  def save(product)
    client.prepare("UPDATE #{TABLE_NAME} SET stock = ? WHERE id = ?")
          .execute(product.stock, product.id)
  end
end
