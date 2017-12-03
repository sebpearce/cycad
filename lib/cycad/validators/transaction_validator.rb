require 'dry-validation'

module Cycad
  module Validators
    class TransactionValidator
      def self.validate(input)
        schema = Dry::Validation.Schema do
          required(:date).filled(:date?)
          required(:amount).filled(:int?, excluded_from?: [0])
          required(:category_id).filled(:str?)
          optional(:note).maybe(:str?, max_size?: 255)
          optional(:tags).maybe(:array?)
        end

        schema.call(input)
      end

      def self.partial_validate(input)
        schema = Dry::Validation.Schema do
          optional(:date).filled(:date?)
          optional(:amount).filled(:int?, excluded_from?: [0])
          optional(:category_id).filled(:str?)
          optional(:note).maybe(:str?, max_size?: 255)
          optional(:tags).maybe(:array?)
        end

        schema.call(input)
      end
    end
  end
end
