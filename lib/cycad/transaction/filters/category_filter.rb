module Cycad
  class Transaction
    class CategoryFilter
      def self.filter(transactions, id)
        transactions.select do |transaction|
          transaction.category_id == id
        end
      end
    end
  end
end
