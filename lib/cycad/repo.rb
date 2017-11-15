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

      def update(transaction, args = {})
        transaction.update(args)
      end

      def count
        transactions.count
      end

      def purge(transaction)
        transactions.delete(transaction)
      end

      def purge_all
        @transactions = []
      end
    end
  end
end
