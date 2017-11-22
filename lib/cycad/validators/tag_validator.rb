require 'dry-validation'

module Cycad
  module Validators
    class TagValidator
      def self.validate(tag)
        input = {
          name: tag.name
        }

        schema = Dry::Validation.Schema do
          required(:name).filled(:str?, max_size?: 32)
        end

        schema.call(input)
      end
    end
  end
end
