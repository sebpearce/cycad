module Cycad
  module Filters
    class CategoryFilter
      def self.filter_by_category(transactions, id)
        transactions.select do |transaction|
          transaction.category_id == id
        end
      end
    end
  end
end
