module Cycad
  module TransactionsRepo
    class MemoryRepo
      attr_accessor :transactions, :categories, :tags

      def initialize
        @transactions = []
        @categories = []
        @tags = []
      end

      def persist_transaction(transaction)
        transactions << transaction
        transaction
      end

      def find_transaction(id)
        transactions.find { |transaction| transaction.id == id }
      end

      def update_transaction(transaction, args = {})
        transaction.update(args)
      end

      def count
        transactions.count
      end

      def purge_transaction(transaction)
        transactions.delete(transaction)
      end

      def persist_category(category)
        categories << category
        category
      end

      def find_category(id)
        categories.find { |category| category.id == id }
      end

      def rename_category(category, new_name)
        category.rename(new_name)
      end

      def purge_category(category)
        categories.delete(category)
      end

      def persist_tag(tag)
        tags << tag
        tag
      end

      def find_tag(id)
        tags.find { |tag| tag.id == id }
      end

      def rename_tag(tag, new_name)
        tag.name = new_name
      end
      
      def attach_tag(transaction, tag)
        transaction.tags << tag
      end

      def unattach_tag(transaction, tag)
        transaction.tags.delete(tag)
      end

      def purge_tag(tag)
        tags.delete(tag)
      end

      def purge_all
        @transactions = []
        @categories = []
        @tags = []
      end
    end
  end
end
