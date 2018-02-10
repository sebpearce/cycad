require 'dry-validation'

module Cycad
  class Transaction
    class Validator
      def self.validate_for_create(input)
        schema = Dry::Validation.Schema do
          required(:date).filled(:date?)
          required(:amount).filled(:int?, excluded_from?: [0])
          required(:category_id).filled(:int?)
          optional(:note).maybe(:str?, max_size?: 255)
          optional(:tags).maybe(:str?)
        end

        schema.call(input)
      end

      def self.validate_for_update(input)
        schema = Dry::Validation.Schema do
          optional(:date).filled(:date?)
          optional(:amount).filled(:int?, excluded_from?: [0])
          optional(:category_id).filled(:int?)
          optional(:note).maybe(:str?, max_size?: 255)
          optional(:tags).maybe(:str?)
        end

        schema.call(input)
      end
    end
  end
end
