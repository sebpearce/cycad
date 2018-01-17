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

# Homework 2017-11-29

# Notes from session

Cycad::Repository.register(:category, Database::CategoryRepo.new(Database::Config::Rom))
Cycad::Repository.register(:transaction, Database::TransactionRepo.new(Database::Config::Rom))

module Cycad
  class << self
    def transactions
      Cycad::Repository.for(:transaction).all
    end

    def create_transaction(args = {})
      Cycad::Transaction::UseCases::Create.new.call(args)
    end

    def delete_transaction(id)
      # TODO should this have 1 step and use `call`, like create does?
      Cycad::Transaction::UseCases::Delete.new.delete(id: id)
    end

    def update_transaction(id, attrs)
      Cycad::Transaction::UseCases::Update.new.call(id: id, attrs: attrs)
    end

    def create_category(name)
      Cycad::Category::UseCases::Create.new.call(name: name)
    end

    # def rename_category(id, new_name)
    #   Cycad::Category::Interactor.rename(id, new_name)
    # end
    #
    # def remove_category(id)
    #   Cycad::Category::Interactor.remove(id)
    # end

    # purge_all
  end
end
