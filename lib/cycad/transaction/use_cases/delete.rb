module Cycad
  class Transaction
    module UseCases
      class Delete
        def delete(input)
          repo.delete(input[:id])
        end

        private

        def repo
          Cycad::Repository.for(:transaction)
        end
      end
    end
  end
end

