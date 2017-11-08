require 'cycad/version'
require 'cycad/repo'
require 'cycad/transaction'
require 'cycad/transactions'
require 'cycad/filters/date_filter'
require 'cycad/filters/amount_filter'
require 'cycad/filters/category_filter'

# Homework 2017-11-01

# - Defining `Transactions#inspect`
# - Can you make the amount filter accept arbitrary things like `{ |a| a > 100 }` or `{ |a| a < -100 }`?  Not `{ |t| t.amount < 100 }`
# - Tidy up `amount_filter.rb` by leaning on the `filter_by` method.
# - Adding tagging to transactions (i.e. Christmas 2017)
# - Look into adding transactions, removing transactions and updating existing transactions

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
