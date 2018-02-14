require 'rom-repository'

module Database
  class TransactionRepo < ROM::Repository[:transactions]
    struct_namespace Cycad
    commands :create, update: :by_pk, delete: :by_pk, mapper: :transaction

    def query(conditions = true, &block)
      transactions.where(conditions, &block)
    end

    def filter(amount:, date:, category_id:, tags:)
      filtered = transactions
      filtered = amount_filter(filtered, **amount)
      filtered.to_a
    end

    def amount_filter(filtered = transactions, lt: nil, gt: nil)
      if lt
        filtered = filtered.where { amount < lt }
      end

      if gt
        filtered = filtered.where { amount > gt}
      end

      filtered
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
  end
end
