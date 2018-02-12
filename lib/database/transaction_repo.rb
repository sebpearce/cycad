require 'rom-repository'

module Database
  class TransactionRepo < ROM::Repository[:transactions]
    commands :create, update: :by_pk, delete: :by_pk, mapper: :transaction

    def query(conditions, &block)
      transactions.where(conditions, &block).map_to(Cycad::Transaction).to_a
    end

    def filter(&block)
      transactions.where(&block).map_to(Cycad::Transaction).to_a
    end

    def income_only
      transactions.where { amount > 0 }.map_to(Cycad::Transaction).to_a
    end

    def expenses_only
      transactions.where { amount < 0 }.map_to(Cycad::Transaction).to_a
    end

    def by_id(id)
      transactions.by_pk(id).map_to(Cycad::Transaction).one
    end

    def all
      transactions.map_to(Cycad::Transaction).to_a
    end

    def delete_all
      transactions.delete
    end

    private

    def transactions
      super.map_to(Cycad::Transaction)
    end
  end
end
