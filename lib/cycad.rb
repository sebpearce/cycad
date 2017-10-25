require 'cycad/version'
require 'cycad/repo'
require 'cycad/transaction'

# homework

# implement filter_transactions
# filter should be able to filter by:
# - date range
# - whether it's an income or expense
# - what category it has

# delete repo class, write tests, rewrite and make all tests pass

module Cycad
  class << self
    def repo
      @repo ||= TransactionsRepo::MemoryBucket.new
    end

    def add_transaction(transaction)
      repo.persist(transaction)
    end

    def find_transaction(id)
      repo.find(id)
    end
  end
end
