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

# * Use `ROM::Struct` in models to enforce types on attributes and to clean up the `initializer` code.

# Homework 2018-01-31

# Use Cycad "in anger" and fix bugs / add features as neccessary
# * Submit a pull request to remove register_at

# Notes from 2018-02-22
# controller will:
# - provide the route
# - pass off the work to a use case class
# - handle success and failure (404 etc)

Cycad::Repository.register(:category, Database::CategoryRepo.new(Database::Config::Rom))
Cycad::Repository.register(:transaction, Database::TransactionRepo.new(Database::Config::Rom))

module Cycad
  class << self
    def transactions
      Cycad::Repository.for(:transaction).all
    end

    def create_transaction(attrs = {})
      # TODO extract this to a type checker module
      raise "Please give me a hash." unless attrs.is_a? Hash
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
