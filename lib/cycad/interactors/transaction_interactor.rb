module Cycad
  module Interactors
    class Transaction < Base
      EditResult = Struct.new(:transaction, :errors)

      def self.create(args)
        validation = Cycad::Validators::TransactionValidator.validate(args)
        return EditResult.new(nil, validation.errors) if validation.failure?
        transaction = Cycad::Transaction.new(args)
        repo.persist_transaction(transaction)
        EditResult.new(transaction, {})
      end

      def self.remove(id)
        transaction = Cycad.repo.find_transaction(id)
        Cycad.repo.purge_transaction(transaction)
      end

      def self.update(id, args)
        validation = Cycad::Validators::TransactionValidator.partial_validate(args)
        return EditResult.new(nil, validation.errors) if validation.failure?
        transaction = Cycad.repo.find_transaction(id)
        Cycad.repo.update_transaction(transaction, args)
        EditResult.new(transaction, {})
      end
    end
  end
end
