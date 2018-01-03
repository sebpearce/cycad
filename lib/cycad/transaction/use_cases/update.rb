module Cycad
  class Transaction
    module UseCases
      class Update
        include Dry::Transaction

        step :validate

        def validate(id:, attrs:)
          p id, attrs
        end
      end
    end
  end
end
