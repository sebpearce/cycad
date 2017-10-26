require 'pry'
require 'UUID'

module TransactionsRepo
  class MemoryRepo
    attr_accessor :transactions

    def initialize
      @transactions = []
      @uuid = UUID.new # shouldn't we do this when a transaction is init'ed?
    end

    def persist(transaction)
      transaction.id = @uuid.generate # this has side effect on transactions…
      transactions << transaction
      transaction
    end

    def find(id)
      transactions.find { |transaction| transaction.id == id }
    end

    def count
      transactions.count
    end
  end
end
