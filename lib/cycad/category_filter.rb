module Cycad
  module Filters
    class CategoryFilter
      def self.category_filter(transactions, id)
        transactions.select do |transaction|
          transaction.category_id == id
        end
      end
    end
  end
end
