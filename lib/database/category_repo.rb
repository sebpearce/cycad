require 'rom-repository'

module Database
  class CategoryRepo < ROM::Repository[:categories]
    commands :create, update: :by_pk, delete: :by_pk, mapper: :category

    def query(conditions)
      categories.where(conditions).to_a
    end

    def by_id(id)
      categories.by_pk(id).one
    end

    def by_name(name)
      categories.where(name: name).one
    end

    def unique?(name)
      categories.unique?(name: name)
    end

    def all
      categories.to_a
    end

    def rename(id, new_name)
      update(id, name: new_name)
    end

    def delete_all
      categories.delete
    end

    private

    def categories
      super.map_to(Cycad::Category)
    end
  end
end
