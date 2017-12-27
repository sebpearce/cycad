require 'cycad/transaction/use_cases/create'

module Cycad
  class Transaction
    class Interactor
      EditResult = Struct.new(:transaction, :errors)

      def self.create(input)
        create_usecase.call(input)
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

      def self.create_usecase
        UseCases::Create.new
      end

      private

      def self.repo
        Cycad::Repository.for(:transaction)
      end
    end
  end
end
