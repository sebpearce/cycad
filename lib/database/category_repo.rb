require 'rom-repository'

module Database
  class CategoryRepo < ROM::Repository[:categories]
    commands :create, update: :by_pk, delete: :by_pk, mapper: :category

    def query(conditions)
      categories.where(conditions).map_to(Cycad::Category).to_a
    end

    def by_id(id)
      categories.by_pk(id).map_to(Cycad::Category).one
    end

    def by_name(name)
      categories.where(name: name).map_to(Cycad::Category).one
    end

    def all
      categories.map_to(Cycad::Category).to_a
    end

    def rename(id, new_name)
      update(id, name: new_name)
    end

    def delete_all
      categories.delete
    end
  end
end
