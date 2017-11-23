module Cycad
  module Interactors
    class Tag
      def self.create(name)
        Cycad::Tag.new(name)
      end

      def self.attach(transaction, tag)
        transaction.tags << tag
      end

      def self.remove(transaction, tag)
        transaction.tags.delete(tag)
      end
    end
  end
end
