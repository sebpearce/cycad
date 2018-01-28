require 'dotenv/load'
require 'cycad/version'
require 'cycad/repo'
require 'in_memory_db/category_repo'
require 'in_memory_db/transaction_repo'
require 'database/config'
require 'database/category_repo'
require 'database/transaction_repo'
require 'cycad/transaction/use_cases/create'
require 'cycad/transaction/use_cases/update'
require 'cycad/transaction/use_cases/delete'
require 'cycad/category'
require 'cycad/category/category_mapper'
require 'cycad/category/use_cases/create'
require 'cycad/category/use_cases/rename'
require 'cycad/category/use_cases/delete'
require 'cycad/category/category_validator'
require 'cycad/transaction'
require 'cycad/transaction/transaction_validator'
require 'cycad/transaction/filters/date_filter'
require 'cycad/transaction/filters/amount_filter'
require 'cycad/transaction/filters/category_filter'
require 'cycad/transaction/use_cases/update'
require 'cycad/transaction/use_cases/create'

# Homework 2018-01-21

# * Use a non-in-memory database so that records actually live longer than the console session
#     --> http://rom-rb.org/4.0/learn/getting-started/setup-dsl/
# * Abstract relations out of database configuration into their own classes
# * Add migrations to the application and make it so that you can run them
# * Use `ROM::Struct` in models to enforce types on attributes and to clean up the `initializer` code.

# Homework 2018-01-24

# * Create a hash method in your category and transaction classes
# * Add migrations to the application and make it so that you can run them on both a development and test database
# * Submit a pull request to remove register_at

Cycad::Repository.register(:category, Database::CategoryRepo.new(Database::Config::Rom))
Cycad::Repository.register(:transaction, Database::TransactionRepo.new(Database::Config::Rom))

module Cycad
  class << self
    def transactions
      Cycad::Repository.for(:transaction).all
    end

    def create_transaction(attrs = {})
      Cycad::Transaction::UseCases::Create.new.call(attrs)
    end

    def update_transaction(id, attrs)
      Cycad::Transaction::UseCases::Update.new.call(id: id, attrs: attrs)
    end

    def delete_transaction(id)
      Cycad::Transaction::UseCases::Delete.new.delete(id: id)
    end

    def categories
      Cycad::Repository.for(:category).all
    end

    def create_category(name)
      Cycad::Category::UseCases::Create.new.call(name: name)
    end

    def rename_category(id, new_name)
      Cycad::Category::UseCases::Rename.new.call(id: id, name: new_name)
    end

    def delete_category(id)
      Cycad::Category::UseCases::Delete.new.delete(id: id)
    end
  end
end
