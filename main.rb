require 'mysql2'
require_relative './adapter/mysql/user_repository'
require_relative './adapter/mysql/product_repository'
require_relative './adapter/mysql/order_repository'
require_relative './usecase/purchase_product'

def purchase_product_request(user_id, product_title, count)
  mysql_client = Mysql2::Client.new({
    host: "127.0.0.1",
    username: "root",
    password: "root",
    database: "test"
  })
  user_repository = UserRepository.new(mysql_client)
  product_repository = ProductRepository.new(mysql_client)
  order_repository = OrderRepository.new(mysql_client)
  purchase_product = PurchaseProduct.new(user_repository, product_repository, order_repository)

  purchase_product.run(user_id, product_title, count)
end

def purchase_product_request_repo(user_id, product_title, count)
  mysql_client = Mysql2::Client.new({
    host: "127.0.0.1",
    username: "root",
    password: "root",
    database: "test"
  })
  user_repository = UserRepository.new(mysql_client)
  product_repository = ProductRepository.new(mysql_client)
  order_repository = OrderRepository.new(mysql_client)
  aggregate_root_repository = AggregateRootRepository.new(mysql_client)
  purchase_product = PurchaseProduct.new(user_repository, product_repository, order_repository, aggregate_root_repository)

  purchase_product.run_in_repo(user_id, product_title, count)
end
