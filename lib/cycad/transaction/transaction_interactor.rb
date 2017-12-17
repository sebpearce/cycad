module Cycad
  class Transaction
    class Interactor
      EditResult = Struct.new(:transaction, :errors)

      def self.create(args)
        validation = Cycad::Transaction::Validator.validate(args)
        return EditResult.new(nil, validation.errors) if validation.failure?
        transaction = repo.create(args)
        EditResult.new(transaction, {})
      end

      def self.remove(id)
        repo.delete(id)
      end

      def self.update(id, args)
        validation = Cycad::Transaction::Validator.partial_validate(args)
        return EditResult.new(nil, validation.errors) if validation.failure?
        transaction = repo.update(id, args)
        EditResult.new(transaction, {})
      end

      private

      def self.repo
        Cycad::Repository.for(:transaction)
      end
    end
  end
end
