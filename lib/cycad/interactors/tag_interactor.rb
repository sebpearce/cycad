module Cycad
  module Interactors
    class Tag
      def self.create(name)
        tag = Cycad::Tag.new(name)
        Cycad.repo.persist_tag(tag)
      end

      def self.rename(id, new_name)
        tag = Cycad.repo.find_tag(id)
        Cycad.repo.rename_tag(tag, new_name)
      end

      def self.attach(transaction_id, tag_id)
        transaction = Cycad.repo.find_transaction(transaction_id)
        tag = Cycad.repo.find_tag(tag_id)
        Cycad.repo.attach_tag(transaction, tag)
      end

      def self.unattach(transaction_id, tag_id)
        transaction = Cycad.repo.find_transaction(transaction_id)
        tag = Cycad.repo.find_tag(tag_id)
        Cycad.repo.unattach_tag(transaction, tag)
      end

      def self.purge(id)
        tag = Cycad.repo.find_tag(id)
        Cycad.repo.purge_tag(tag)
      end
    end
  end
end
