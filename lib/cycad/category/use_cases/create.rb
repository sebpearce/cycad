require 'dry/transaction'

module Cycad
  class Category
    module UseCases
      class Create
        include Dry::Transaction

        step :validate
        step :create

        def validate(input)
          validation = Cycad::Category::Validator.validate(repo, input)
          if validation.success?
            Right(input)
          else
            Left(validation.errors)
          end
        end

        def create(input)
          category = repo.create(input)
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
