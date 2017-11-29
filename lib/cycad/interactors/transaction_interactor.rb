module Cycad
  module Interactors
    class Transaction
      def self.add(args)
        transaction = Cycad::Transaction.new(args)
        Cycad.repo.persist_transaction(transaction)
      end

      def self.remove(id)
        transaction = Cycad.repo.find_transaction(id)
        Cycad.repo.purge_transaction(transaction)
      end

      def self.update(id, args)
        transaction = Cycad.repo.find_transaction(id)
        Cycad.repo.update_transaction(transaction, args)
      end
    end
  end
end
