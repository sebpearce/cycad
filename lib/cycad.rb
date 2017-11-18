require 'cycad/version'
require 'cycad/repo'
require 'cycad/category'
require 'cycad/transaction'
require 'cycad/transactions'
require 'cycad/tag'
require 'cycad/tagger'
require 'cycad/filters/date_filter'
require 'cycad/filters/amount_filter'
require 'cycad/filters/category_filter'
require 'cycad/validators/transaction_validator'

# Homework 2017-11-15

# - Validations!
# - dry-validations, enforcing schemas
# - Validating the types of fields
# - Validate transaction amount is not a zero dollar amount
# - Notes for a transaction can't be longer than 255 characters
# - Category has to have a name, and has to be shorter than a specific amount
# - Tag has to have a name, and has to be shorter than a specific amount
# - Stretch goal: Hooking it up to rom-rb: [ROM](http://rom-rb.org/) and a real database

# Notes

# - We have to persist categories and tags as well.


module Cycad
  class << self
    def repo
      @repo ||= TransactionsRepo::MemoryRepo.new
    end
    
    def add_transaction(transaction)
      repo.persist_transaction(transaction)
    end

    def remove_transaction(transaction)
      repo.purge_transaction(transaction)
    end

    def find_transaction(id)
      repo.find_transaction(id)
    end

    def purge_all
      repo.purge_all
    end

    def tag_transaction(transaction, tag)
      Tagger.attach_tag(transaction, tag)
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
  end
end
