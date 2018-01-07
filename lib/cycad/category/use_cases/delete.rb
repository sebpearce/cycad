module Cycad
  class Category
    module UseCases
      class Delete
        def delete(input)
          repo.delete(input[:id])
        end

        private

        def repo
          Cycad::Repository.for(:category)
        end
      end
    end
  end
end

