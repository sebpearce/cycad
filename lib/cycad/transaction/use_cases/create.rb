require 'dry/transaction'

module Cycad
  class Transaction
    module UseCases
      class Create
        include Dry::Transaction

        step :validate
        step :create

        def validate(input)
          validation = Cycad::Transaction::Validator.validate_for_create(input)
          if validation.success?
            Right(input)
          else
            Left(validation.errors)
          end
        end

        def create(input)
          transaction = repo.create(input)
          Right(transaction)
        end

        private

        def repo
          Cycad::Repository.for(:transaction)
        end
      end
    end
  end
end

