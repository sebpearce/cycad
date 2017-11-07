module Cycad
  module Filters
    class DateFilter
      def self.filter_by_date_range(transactions, start_date, end_date)
        range = start_date..end_date
        transactions.select do |transaction|
          range.cover?(transaction.date)
        end
      end
    end
  end
end
