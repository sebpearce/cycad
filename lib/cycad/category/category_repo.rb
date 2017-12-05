module Cycad
  module Category
    class CategoryRepo
      attr_accessor :categories

      def initialize
        @categories = []
      end

      def find_by_id(id)
        categories.find { |category| category.id == id }
      end

      def rename(category, new_name)
        category.rename(new_name)
      end

      def purge(category)
        categories.delete(category)
      end
      
      def purge_all
        @categories = []
      end
    end
  end
end
