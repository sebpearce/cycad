require 'dry/transaction'

module Cycad
  class Category
    module UseCases
      class Rename
        include Dry::Transaction

        step :validate
        step :rename

        def validate(input)
          validation = Cycad::Category::Validator.validate(input)
          if validation.success?
            Right(input)
          else
            Left(validation.errors)
          end
        end

        def rename(input)
          category = repo.rename(input)
          Right(category)
        end

        private

        def repo
          Cycad::Repository.for(:category)
        end
      end
    end
  end
end
