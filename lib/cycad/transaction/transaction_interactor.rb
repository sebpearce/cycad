module Cycad
  module Transaction
    class Interactor < Cycad::InteractorBase
      EditResult = Struct.new(:transaction, :errors)
      
      def self.create(args)
        validation = Cycad::Transaction::Validator.validate(args)
        return EditResult.new(nil, validation.errors) if validation.failure?
        transaction = Cycad::Transaction::TransactionEntity.new(args)
        repo.persist_transaction(transaction)
        EditResult.new(transaction, {})
      end

      def self.remove(id)
        transaction = Cycad.repo.find_transaction(id)
        Cycad.repo.purge_transaction(transaction)
      end

      def self.update(id, args)
        validation = Cycad::Transaction::Validator.partial_validate(args)
        return EditResult.new(nil, validation.errors) if validation.failure?
        transaction = Cycad.repo.find_transaction(id)
        Cycad.repo.update_transaction(transaction, args)
        EditResult.new(transaction, {})
      end
    end
  end
end
