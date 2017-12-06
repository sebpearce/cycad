module Cycad
  class Tag
    class TagRepo
      attr_accessor :tags

      def initialize
        @tags = []
      end

      def persist(tag)
        tags << tag
        tag
      end

      def find_by_id(id)
        tags.find { |tag| tag.id == id }
      end

      def rename(tag, new_name)
        tag.name = new_name
      end
      
      def attach(transaction, tag)
        transaction.tags << tag
      end

      def unattach(transaction, tag)
        transaction.tags.delete(tag)
      end

      def purge(tag)
        tags.delete(tag)
      end
      
      def purge_all
        @tags = []
      end
    end
  end
end
