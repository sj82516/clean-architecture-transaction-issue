require 'mysql2'
require_relative 'main'
require_relative './adapter/mysql/user_repository'
require_relative './adapter/mysql/product_repository'
require_relative './adapter/mysql/order_repository'
require_relative './adapter/mysql/aggregate_root_repository'
require_relative './usecase/purchase_product'

describe "main" do
  let(:user_repository) { double('UserRepository') }
  let(:product_repository) { double('ProductRepository') }
  let(:order_repository) { double('OrderRepository') }

  context "usecase control transaction" do
    it "success" do
      user = User.new(1, 1000)
      product = Product.new(1, 10, 100)
      allow(user_repository).to receive(:transaction)
      allow(user_repository).to receive(:commit)
      allow(user_repository).to receive(:find_by_id_with_lock).and_return(user)
      allow(product_repository).to receive(:find_by_id_with_lock).and_return(product)

      expect(user_repository).to receive(:save).with(user)
      expect(product_repository).to receive(:save).with(product)
      expect(order_repository).to receive(:create) do |order|
        expect(order.user.id).to eql(1)
        expect(order.product.id).to eql(1)
        expect(order.count).to eql(10)
      end

      purchase_product = PurchaseProduct.new(user_repository, product_repository, order_repository, nil)
      purchase_product.run(1, 1, 10)

      expect(user.points).to eql(900)
      expect(product.stock).to eql(90)
    end
  end

  context "repo controll transaction" do
    it "success" do
      # how to test ?!
    end
  end
end
