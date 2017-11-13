module Cycad
  module TransactionsRepo
    class MemoryRepo
      attr_accessor :transactions

      def initialize
        @transactions = []
      end

      def persist(transaction)
        transactions << transaction
        transaction
      end

      def find(id)
        transactions.find { |transaction| transaction.id == id }
      end

      def count
        transactions.count
      end

      def purge(id)
        transactions.replace(
          transactions.select { |transaction| transaction.id != id }
        )
      end

      def purge_all
        @transactions = []
      end
    end
  end
end
