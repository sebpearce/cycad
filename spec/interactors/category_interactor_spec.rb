require 'spec_helper'

RSpec.describe Cycad::Interactors::Category do
  describe 'categories' do
    context 'self.add' do
      context 'when the category name is valid' do
        it 'adds a category' do
          Cycad::Interactors::Category.add('uni')
          expect(Cycad.repo.categories.first.name).to eq('uni')
        end
      end

      context 'when the category name is invalid' do
        it 'returns an error' do
          result = Cycad::Interactors::Category.add('')
          expect(result.errors).to eq({name: ["must be filled"]})
        end
      end
    end

    context 'self.rename' do
      before do
        existing_category = Cycad::Interactors::Category.add('food')
        @the_id = existing_category.id
      end

      it 'renames a category' do
        Cycad::Interactors::Category.rename(@the_id, 'NEW_NAME')
        expect(Cycad.repo.categories.first.name).to eq('NEW_NAME')
      end
    end

    context 'self.remove' do
      before do
        @category2 = Cycad::Interactors::Category.add('pizza')
      end

      it 'removes a category' do
        expect(Cycad.repo.categories).to include(@category2)
        Cycad::Interactors::Category.remove(@category2.id)
        expect(Cycad.repo.categories).to_not include(@category2)
      end
    end
  end
end
