require 'cycad/version'
require 'cycad/repo'
require 'cycad/category'
require 'cycad/transaction'
require 'cycad/transactions'
require 'cycad/tag'
require 'cycad/filters/date_filter'
require 'cycad/filters/amount_filter'
require 'cycad/filters/category_filter'
require 'cycad/validators/transaction_validator'
require 'cycad/validators/category_validator'
require 'cycad/validators/tag_validator'
require 'cycad/interactors/base'
require 'cycad/interactors/category_interactor'
require 'cycad/interactors/tag_interactor'
require 'cycad/interactors/transaction_interactor'

# Homework 2017-11-29

# - Create uniqueness checker classes (one for category, one for tag, etc) -- checks the database for existing items
# - [dry-rb - dry-validation - Comparison With ActiveModel](http://dry-rb.org/gems/dry-validation/comparison-with-activemodel/) - Section 2.11 uniqueness validator
# - `schema.with(repo: repo).call(input)`
  # - Cautious about injecting entire repo, can you inject just a CategoryUniquenessValidator that encapsulated uniqueness logic? It should only have one method to validate the category's uniqueness.
  # - Possibly initialized like `CategoryUniquenessValidator.new(repo).unique?(name)`

# Notes
# - Does it make sense to return an "EditResult" with the tag/transaction/category in it on a rename, as I've done? Or just a create?


module Cycad
  class << self
    def repo
      @repo ||= TransactionsRepo::MemoryRepo.new
    end

    def create_transaction(args = {})
      Cycad::Interactors::Transaction.create(args)
    end

    def remove_transaction(id)
      Cycad::Interactors::Transaction.remove(id)
    end

    def update_transaction(id, args)
      Cycad::Interactors::Transaction.update(id, args)
    end

    def create_category(name)
      Cycad::Interactors::Category.create(name)
    end

    def rename_category(id, new_name)
      Cycad::Interactors::Category.rename(id, new_name)
    end

    def remove_category(id)
      Cycad::Interactors::Category.remove(id)
    end

    def create_tag(name)
      Cycad::Interactors::Tag.create(name)
    end

    def rename_tag(id, new_name)
      Cycad::Interactors::Tag.rename(id, new_name)
    end

    def purge_tag(id)
      Cycad::Interactors::Tag.purge(id)
    end

    def tag_transaction(transaction_id, tag_id)
      Cycad::Interactors::Tag.attach(transaction_id, tag_id)
    end

    def untag_transaction(transaction_id, tag_id)
      Cycad::Interactors::Tag.unattach(transaction_id, tag_id)
    end

    def filter_transactions(date_range: nil, type: nil, category_id: nil)
      result = repo.transactions

      if date_range && date_range.has_key?(:start_date) && date_range.has_key?(:end_date)
        result = Filters::DateFilter::DateRange.filter(
            result,
            date_range[:start_date],
            date_range[:end_date]
          )
      end

      if type == :income_only
        result = Filters::AmountFilter::IncomeOnly.filter(result)
      elsif type == :expenses_only
        result = Filters::AmountFilter::ExpensesOnly.filter(result)
      end

      if category_id
        result = Filters::CategoryFilter.filter(result, category_id)
      end

      result
    end

    def purge_all
      repo.purge_all
    end
  end
end
