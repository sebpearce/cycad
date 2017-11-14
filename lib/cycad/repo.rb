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
      
      def update(id, args = {})
        # Transaction has attr_readers only,
        # need to make a new transaction here
        transaction = find(id)
        args.each do |key, value|
          transaction.instance_variable_set("@#{key}", value)
        end
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
