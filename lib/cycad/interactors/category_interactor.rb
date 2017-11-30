module Cycad
  module Interactors
    class Category < Base
      CreateResult = Struct.new(:category, :errors)

      def self.create(name)
        category = Cycad::Category.new(name)
        validation = Cycad::Validators::CategoryValidator.validate(category)
        return CreateResult.new(nil, validation.errors) if validation.failure?
        # instantiate category here
        repo.persist_category(category)
        CreateResult.new(category, {})
      end

      def self.rename(id, new_name)
        category = find_category(id)
        repo.rename_category(category, new_name)
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
