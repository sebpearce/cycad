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
    Rom = ROM.container(:sql, "sqlite::memory") do |conf|
      conf.register_relation(Database::Relations::Categories)
      conf.register_relation(Database::Relations::Transactions)
      conf.register_mapper(Cycad::CategoryMapper)
      conf.register_mapper(Cycad::TransactionMapper)
    end
  end
end


# Migrations - put these somewhere more sensible

gateway = Database::Config::Rom.gateways[:default]

categories_migration = gateway.migration do
  change do
    create_table :categories do
      primary_key :id
      column :name, String, null: false
    end
  end
end

transactions_migration = gateway.migration do
  change do
    create_table :transactions do
      primary_key :id
      foreign_key :category_id, :categories, null: false
      column :amount, Integer, null: false
      column :date, Date, null: false
      column :note, String
      column :tags, String
    end
  end
end

categories_migration.apply(gateway.connection, :up)
transactions_migration.apply(gateway.connection, :up)
