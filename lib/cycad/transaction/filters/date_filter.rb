module Cycad
  class Transaction
    class DateFilter
      class DateRange
        def self.filter(transactions, start_date, end_date)
          range = start_date..end_date
          transactions.select do |transaction|
            range.cover?(transaction.date)
          end
        end
      end
    end
  end
end
