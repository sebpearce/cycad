require 'rom-repository'

module Database
  class CategoryRepo < ROM::Repository[:categories]
    commands :create, update: :by_pk, delete: :by_pk

    def query(conditions)
      categories.where(conditions).to_a
    end

    def by_id(id)
      categories.by_pk(id).one!
    end

    def all
      categories.to_a
    end
  end
end
