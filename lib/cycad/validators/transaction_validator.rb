require 'dry-validation'

module Cycad
  module Validators
    class TransactionValidator
      def self.validate(transaction)
        input = {
          date: transaction.date,
          amount: transaction.amount,
          category_id: transaction.category_id,
          note: transaction.note,
          tags: transaction.tags,
        }

        schema = Dry::Validation.Schema do
          required(:date).filled(:date?)
          required(:amount).filled(:int?, excluded_from?: [0])
          required(:category_id).filled(:str?)
          optional(:note).maybe(:str?, max_size?: 255)
          optional(:tags).maybe(:array?)
        end

        schema.call(input)
      end
    end
  end
end
