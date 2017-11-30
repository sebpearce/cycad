# repo = double
# allow(Cyad::Interactors:Tag).to receive(:repo) { repo }
#
# expect(repo).to receive(:persist_tag)
# Cycad::Interactors::Tag.create
#
module Cycad
  module Interactors
    class Tag < Base
      def self.create(name)
        tag = Cycad::Tag.new(name)
        repo.persist_tag(tag)
      end

      def self.rename(id, new_name)
        repo.rename_tag(find_tag(id), new_name)
      end

      def self.attach(transaction_id, tag_id)
        transaction = repo.find_transaction(transaction_id)
        repo.attach_tag(transaction, find_tag(tag_id))
      end

      def self.unattach(transaction_id, tag_id)
        transaction = repo.find_transaction(transaction_id)
        repo.unattach_tag(transaction, find_tag(tag_id))
      end

      def self.purge(id)
        repo.purge_tag(find_tag(id))
      end

      private

      def self.find_tag(id)
        repo.find_tag(id)
      end
    end
  end
end
