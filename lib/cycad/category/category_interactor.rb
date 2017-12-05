module Cycad
  module Interactors
    class Category < Base
      EditResult = Struct.new(:category, :errors)

      def self.create(name)
        validation = Cycad::Validators::CategoryValidator.validate(name: name)
        return EditResult.new(nil, validation.errors) if validation.failure?
        category = Cycad::Category.new(name)
        repo.persist_category(category)
        EditResult.new(category, {})
      end

      def self.rename(id, new_name)
        validation = Cycad::Validators::CategoryValidator.validate(name: name)
        return EditResult.new(nil, validation.errors) if validation.failure?
        category = find_category(id)
        repo.rename_category(category, new_name)
        EditResult.new(category, {})
      end

      def self.remove(id)
        category = find_category(id)
        repo.purge_category(category)
      end

      private

      def self.find_category(id)
        repo.find_category(id)
      end
    end
  end
end
