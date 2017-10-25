require 'pry'
require 'UUID'

module TransactionsRepo
  class MemoryBucket
    def initialize
      @transactions = []
      @uuid = UUID.new
    end

    def persist(transaction)
      transaction.id = @uuid.generate
      transactions << transaction
      transaction
    end

    def find(id)
      transactions.find {|t| t.id == id }
    end

    def count
      transactions.count
    end

    private

    attr_reader :transactions
  end
end
