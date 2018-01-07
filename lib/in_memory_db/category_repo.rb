module Cycad
  module InMemoryDB
    class CategoryRepo
      Category = Struct.new(:id, :name)

      attr_accessor :categories

      def initialize
        @categories = []
        @id = 0
      end

      def create(name:)
        new_category = Category.new(@id, name)
        @categories << new_category
        @id += 1
        new_category
      end

      def update(id, args)
        return if args[:name] == nil
        category = rename(id, args[:name])
        category
      end

      def delete(id)
        category = by_id(id)
        categories.delete(category)
      end

      def all
        categories
      end

      def by_id(id)
        categories.find { |category| category.id == id }
      end

      def rename(id, new_name)
        category = by_id(id)
        category.name = new_name
        category
      end

      # def purge_all
      #   @categories = []
      # end
    end
  end
end
