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

      def purge_all
        @transactions = []
      end

      def filter(date_range: nil, type: nil, category_id: nil)
        result = transactions

        if date_range
          raise ArgumentError, 'Wrong date range format' if
            !date_range[:start_date] || !date_range[:end_date]

          result = result.select do |transaction|
            transaction.date > date_range[:start_date] &&
            transaction.date < date_range[:end_date]
          end
        end

        if type
          result = result.select do |transaction|
            if type == :income
              transaction.amount > 0
            elsif type == :expense
              transaction.amount < 0
            else
              raise ArgumentError, 'Wrong transaction type format'
            end
          end
        end

        if category_id
          raise ArgumentError, 'Wrong category format' if !category_id.is_a? Numeric

          result = result.select do |transaction|
            transaction.category_id == category_id
          end
        end

        result
      end
    end
  end
end
