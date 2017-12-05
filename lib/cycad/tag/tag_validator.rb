require 'dry-validation'

module Cycad
  module Tag
    class Validator
      def self.validate(input)
        schema = Dry::Validation.Schema do
          required(:name).filled(:str?, max_size?: 32)
        end

        schema.call(input)
      end
    end
  end
end
