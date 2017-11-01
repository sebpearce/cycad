module Cycad
  class TransactionsFilter
    def self.date_range(transactions, start_date, end_date)
      range = start_date..end_date
      transactions.select do |transaction|
        range.cover?(transaction.date)
      end
    end

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

    def self.category_filter(transactions, id)
      transactions.select do |transaction|
        transaction.category_id == id
      end
    end
  end
end
