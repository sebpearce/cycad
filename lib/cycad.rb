require 'cycad/version'
require 'cycad/repo'
require 'cycad/transaction'
require 'cycad/transaction_category'
require 'cycad/transactions'
require 'cycad/tag'
require 'cycad/filters/date_filter'
require 'cycad/filters/amount_filter'
require 'cycad/filters/category_filter'

# Homework 2017-11-01

# - Adding tagging to transactions (i.e. Christmas 2017)
# - Look into adding transactions, removing transactions and updating existing transactions

# Notes & observations

# - Is the way I've organised the AmountFilter class a good idea?
# - I didn't want to make a "Tagger" that either creates a new tag or looks
#   for an existing one with the same string, because the front end should do 
#   that – user should see autocomplete list while typing so they don't get a
#   tag name slightly wrong and create 2 tags.

module Cycad
  class << self
    def repo
      @repo ||= TransactionsRepo::MemoryRepo.new
    end
    
    def add_transaction(transaction)
      repo.persist(transaction)
    end

    def find_transaction(id)
      repo.find(id)
    end

    def purge_all_transactions
      repo.purge_all
    end

    def tag_transaction(transaction, tag)
      # need to make this immutable and break out the logic
      # have a separate class that tags transactions
      # and it can create a new transaction with the tag and delete the old one
      # then swap it in
      transaction.tags << tag
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
