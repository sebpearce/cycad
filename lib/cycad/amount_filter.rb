module Cycad
  module Filters
    class AmountFilter
      def self.filter_income_only(transactions)
        transactions.select do |transaction|
          transaction.amount > 0
        end
      end

      def self.filter_expenses_only(transactions)
        transactions.select do |transaction|
          transaction.amount < 0
        end
      end
    end
  end
end
