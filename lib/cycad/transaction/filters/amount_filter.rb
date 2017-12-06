module Cycad
  class Transaction
    class AmountFilter
      def self.filter(transactions)
        transactions.select do |transaction|
          yield transaction.amount
        end
      end

      class IncomeOnly
        def self.filter(transactions)
          AmountFilter.filter(transactions) { |a| a > 0 }
        end
      end

      class ExpensesOnly
        def self.filter(transactions)
          AmountFilter.filter(transactions) { |a| a < 0 }
        end
      end

      class AmountRange
        def self.filter(transactions, lower_limit, upper_limit)
          range = lower_limit..upper_limit
          AmountFilter.filter(transactions) { |a| range.cover?(a) }
        end
      end

      class GreaterThan
        def self.filter(transactions, lower_limit)
          AmountFilter.filter(transactions) { |a| a >= lower_limit }
        end
      end

      class LessThan
        def self.filter(transactions, upper_limit)
          AmountFilter.filter(transactions) { |a| a <= upper_limit }
        end
      end
    end
  end
end
