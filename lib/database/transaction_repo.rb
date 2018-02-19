require 'rom-repository'
require 'pry'

module Database
  class TransactionRepo < ROM::Repository[:transactions]
    struct_namespace Cycad
    commands :create, update: :by_pk, delete: :by_pk, mapper: :transaction

    def query(conditions = true, &block)
      transactions.where(conditions, &block).to_a
    end

    def filter(amount: nil, date: nil, category_id: nil, tags: nil)
      filtered = transactions
      filtered = amount_filter(filtered, **amount) if amount
      filtered = date_filter(filtered, **date) if date
      filtered = category_filter(filtered, category_id) if category_id
      filtered.to_a
    end

    def amount_filter(filtered = transactions, le: nil, ge: nil)
      filtered = filtered.where { amount <= le } if le
      filtered = filtered.where { amount >= ge } if ge
      filtered
    end

    def date_filter(filtered = transactions, from: nil, to: nil)
      filtered = filtered.where { date <= to } if to
      filtered = filtered.where { date >= from } if from
      filtered
    end

    def category_filter(filtered = transactions, category_id)
      filtered = filtered.where(category_id: category_id)
      filtered
    end

    def income_only
      transactions.where { amount > 0 }.to_a
    end

    def expenses_only
      transactions.where { amount < 0 }.to_a
    end

    def by_id(id)
      transactions.by_pk(id).one
    end

    def all
      transactions.to_a
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
