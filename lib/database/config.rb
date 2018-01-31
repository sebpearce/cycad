require 'date'
require 'rom'
require 'rom-sql'
require 'rom-repository'
require 'securerandom'
require 'cycad/category/category_mapper'
require 'cycad/transaction/transaction_mapper'
require 'database/category_relation'
require 'database/transaction_relation'

module Database
  class Config
    Rom = ROM.container(:sql, ENV['DATABASE_URL']) do |conf|
      conf.register_relation(Database::Relations::Categories)
      conf.register_relation(Database::Relations::Transactions)
      conf.register_mapper(Cycad::CategoryMapper)
      conf.register_mapper(Cycad::TransactionMapper)
    end
  end
end

