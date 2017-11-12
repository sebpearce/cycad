module Cycad
  module Filters
    class AmountFilter
      def self.filter(transactions)
        transactions.select do |transaction|
          yield transaction.amount
        end
      end

      class IncomeOnly
        def self.filter(transactions)
          transactions.select do |transaction|
            transaction.amount > 0
          end
        end
      end

      class ExpensesOnly
        def self.filter(transactions)
          transactions.select do |transaction|
            transaction.amount < 0
          end
        end
      end

      class AmountRange
        def self.filter(transactions, lower_limit, upper_limit)
          range = lower_limit..upper_limit
          transactions.select do |transaction|
            range.cover?(transaction.amount)
          end
        end
      end

      class GreaterThan
        def self.filter(transactions, lower_limit)
          transactions.select do |transaction|
            transaction.amount >= lower_limit
          end
        end
      end

      class LessThan
        def self.filter(transactions, upper_limit)
          transactions.select do |transaction|
            transaction.amount <= upper_limit
          end
        end
      end
    end
  end
end
