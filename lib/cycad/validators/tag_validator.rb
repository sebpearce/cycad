require 'dry-validation'

module Cycad
  module Validators
    class TagValidator
      def self.validate_new(input)
        schema = Dry::Validation.Schema do
          required(:name).filled(:str?, max_size?: 32)
        end

        result = schema.call(input)
        result.success?
      end
    end
  end
end
