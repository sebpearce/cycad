require 'cycad/version'
require 'cycad/repo'
require 'cycad/transaction'
require 'cycad/transactions'
require 'cycad/date_filter'
require 'cycad/amount_filter'
require 'cycad/category_filter'

# Homework 2017-11-01

# - Adding tagging to transactions (e.g. Christmas 2017)
# - Look into adding, removing and updating existing transactions

# Observations & notes
# - Ahh! Now the filters are no longer coupled to the repo! :)
# = Should all this logic now live in the outer class (the main API below)?
#     Where should the argument validation happen?
# - I can only get the chainable methods to return a Transactions instance.
#   How can I make it return an array but still be chainable?

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

    def filter_transactions(date_range: nil, type: nil, category_id: nil)
      result = repo.transactions

      if date_range && date_range.has_key?(:start_date) && date_range.has_key?(:end_date)
        result = Filters::DateFilter.filter_by_date_range(
            result,
            date_range[:start_date],
            date_range[:end_date]
          )
      end

      if type == :income_only
        result = Filters::AmountFilter.filter_income_only(result)
      elsif type == :expenses_only
        result = Filters::AmountFilter.filter_expenses_only(result)
      end

      if category_id
        result = Filters::CategoryFilter.filter_by_category(result, category_id)
      end

      result
    end
  end
end
