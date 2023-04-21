require 'mysql2'
require_relative 'main'
require_relative './adapter/mysql/user_repository'
require_relative './adapter/mysql/product_repository'
require_relative './adapter/mysql/order_repository'
require_relative './usecase/purchase_product'

describe "main" do
  let(:client) {
    Mysql2::Client.new({
      host: "127.0.0.1",
      username: "root",
      password: "root",
      database: "test"
    })
  }
  let(:user_repository) { UserRepository.new(client) }
  let(:product_repository) { ProductRepository.new(client) }
  let(:order_repository) { OrderRepository.new(client) }

  after do
    user_repository.delete_all
    product_repository.delete_all
    order_repository.delete_all
  end

  context "when purchase product without lock" do
    it "should oversell" do

      user_repository.create(User.new(1, 1000))
      product_repository.create(Product.new(1, 10, 100))

      threads = []
      2.times do
        threads << Thread.new do
          purchase_product_request(1, 1, 10)
        end
      end
      threads.each(&:join)

      expect(order_repository.find_by_user_id(1).size).to eq 2
      expect(user_repository.find_by_id(1).points).to eq 800
    end
  end
end
