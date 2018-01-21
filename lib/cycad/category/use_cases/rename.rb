require 'dry/transaction'

module Cycad
  class Category
    module UseCases
      class Rename
        include Dry::Transaction

        step :validate
        step :rename

        def validate(input)
          validation = Cycad::Category::Validator.validate(repo, input)
          if validation.success?
            Right(input)
          else
            Left(validation.errors)
          end
        end

        def rename(id:, name:)
          category = repo.rename(id, name)
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
