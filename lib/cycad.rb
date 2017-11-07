require 'cycad/version'
require 'cycad/repo'
require 'cycad/transaction'
require 'cycad/date_filter'
require 'cycad/transaction_type_filter'
require 'cycad/category_filter'

# Homework 2017-11-01

# - TransactionsFilter now contains mixed logic for date_range, income_only and expenses.
# - This looks a lot like what you had with the filter method, but it's a class now.
#     Can you explain this class's responsibilities without using the word "and"?
#     If not, then it might be better to split this class up into several, smaller classes.
#     Would this make your class and test code cleaner? How might you namespace the classes?
# - What does the API look like for chaining multiple filters? Can you make it cleaner? ActiveRecord has things like: `transactions.date_range(range).income_only`. Can you make your API that neat too?
# - Can you make the amount filter accept things like `> 100` or `< -100` or even a range
# - Adding tagging to transactions (e.g. Christmas 2017)
# - Look into adding, removing and updating existing transactions

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
      repo.filter(
        date_range: date_range,
        type: type,
        category_id: category_id
      )
    end
  end
end
