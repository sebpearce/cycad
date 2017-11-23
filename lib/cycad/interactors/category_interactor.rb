module Cycad
  module Interactors
    class Category
      def self.create(name)
        category = Cycad::Category.new(name)
        validation = Cycad::Validators::CategoryValidator.validate(category)
        return validation if validation.failure?
        Cycad.repo.persist_category(category)
      end

      def self.rename(id, new_name)
        category = Cycad.repo.find_category(id)
        Cycad.repo.rename_category(category, new_name)
      end
      
      def self.remove(id)
        category = Cycad.repo.find_category(id)
        Cycad.repo.purge_category(category)
      end
    end
  end
end
