# change these to instance methods so it can be instantiated with a repo passed in
# see interactor_base.rb

module Cycad
  class Category
    class Interactor
      EditResult = Struct.new(:category, :errors)

      def self.create(name)
        validation = Cycad::Category::Validator.validate(name: name)
        return EditResult.new(nil, validation.errors) if validation.failure?
        category = repo.create(name: name)
        EditResult.new(category, {})
      end

      def self.rename(id, new_name)
        validation = Cycad::Category::Validator.validate(name: new_name)
        return EditResult.new(nil, validation.errors) if validation.failure?
        category = repo.rename(id, new_name)
        EditResult.new(category, {})
      end

      def self.remove(id)
        repo.delete(id)
      end

      private

      def self.find(id)
        repo.find(id)
      end

      def self.repo
        Cycad::Repository.for(:category)
      end
    end
  end
end
