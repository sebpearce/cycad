module Cycad
  module Filters
    class TransactionTypeFilter
      def self.income_only(transactions)
        transactions.select do |transaction|
          transaction.amount > 0
        end
      end

      def self.expenses_only(transactions)
        transactions.select do |transaction|
          transaction.amount < 0
        end
      end
    end
  end
end
