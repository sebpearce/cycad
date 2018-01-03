require 'dry-validation'

module Cycad
  class Category
    class Validator
      def self.validate(repo, input)
        schema = Dry::Validation.Schema do
          configure do
            option :repo

            def unique_name?(name)
               repo.by_name(name).empty?
            end
          end

          required(:name).filled(:unique_name?, :str?, max_size?: 32)
        end

        schema.with(repo: repo).call(input)
      end
    end
  end
end
