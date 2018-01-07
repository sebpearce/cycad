require 'dry/transaction'

module Cycad
  class Transaction
    module UseCases
      class Update
        include Dry::Transaction

        step :validate
        step :update

        def validate(input)
          validation = Cycad::Transaction::Validator.partial_validate(input)
          if validation.success?
            Right(input)
          else
            Left(validation.errors)
          end
        end

        def update(input)
          transaction = repo.update(input)
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
