require 'rom-repository'

module Database
  class TransactionRepo < ROM::Repository[:transactions]
    commands :create, update: :by_pk, delete: :by_pk

    def query(conditions)
      transactions.where(conditions).map_to(Cycad::Transaction).to_a
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
