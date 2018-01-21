require 'dry/transaction'

module Cycad
  class Transaction
    module UseCases
      class Update
        include Dry::Transaction

        step :validate
        step :update

        def validate(id:, attrs:)
          validation = Cycad::Transaction::Validator.validate_for_update(attrs)
          if validation.success?
            Right(id: id, attrs: attrs)
          else
            Left(validation.errors)
          end
        end

        def update(id:, attrs:)
          transaction = repo.update(id, attrs)
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
