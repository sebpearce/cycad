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

      def self.filter_amount_range(transactions, lower_limit, upper_limit)
        range = lower_limit..upper_limit
        transactions.select do |transaction|
          range.cover?(transaction.amount)
        end
      end

      def self.filter_greater_than(transactions, lower_limit)
        transactions.select do |transaction|
          transaction.amount >= lower_limit
        end
      end

      def self.filter_less_than(transactions, upper_limit)
        transactions.select do |transaction|
          transaction.amount <= upper_limit
        end
      end
    end
  end
end
