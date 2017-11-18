require 'dry-validation'

module Cycad
  module Validators
    class TransactionValidator
      def self.validate_new(input)
        schema = Dry::Validation.Schema do
          required(:date).filled(:date?)
          required(:amount).filled(:int?, gt?: 0)
          # TODO: check that category id is an existing one
          required(:category_id).filled(:str?)
          optional(:note).filled(:str?, max_size?: 255)
          # TODO: check that tag ids are existing ones
          optional(:tags).value(:array?)
        end

        result = schema.call(input)
        result.success?
      end
    end
  end
end
