require 'mysql2'

class Repository
  def initialize(client)
    self.client = client
  end

  attr_accessor :client
  def transaction
    @client.query('START TRANSACTION')
  end

  def commit
    @client.query('COMMIT')
  end

  def transaction_in_block
    transaction
    yield
    commit
  end

  def delete_all
    @client.query("DELETE FROM #{self.class::TABLE_NAME}")
  end
end
