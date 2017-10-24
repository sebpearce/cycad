module TransactionsRepo
  class MemoryBucket
    def initialize
      @transactions = {}
      uuid = UUID.new
    end

    def persist(transaction)
      id = uuid.generate
      transactions[id] = transaction
    end

    private

    attr_reader :transactions
  end
end
