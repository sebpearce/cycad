require 'spec_helper'

RSpec.describe Cycad::InMemoryDB::CategoryRepo do
  subject { Cycad::InMemoryDB::CategoryRepo.new }

  context '.create' do
    it 'creates a category' do
      subject.create(name: 'test')
      expect(subject.categories.first.name).to eq('test')
    end
  end

  context 'with existing categories' do
    before do
      @walrus = subject.create(name: 'walrus')
      @turkey = subject.create(name: 'turkey')
    end

    context '.by_id' do
      it 'returns the corresponding record' do
        result = subject.by_id(@walrus.id)
        expect(result.name).to eq('walrus')
      end
    end

    context '.all' do
      it 'returns an array of all categories' do
        result = subject.all
        expect(result).to include(@walrus, @turkey)
      end
    end

    context '.delete' do
      it 'deletes a category' do
        subject.delete(@walrus.id)
        expect(subject.categories).to_not include(@walrus)
      end
    end

    context '.update' do
      it 'updates a category' do
        result = subject.update(@walrus.id, name: 'penguin')
        expect(result.name).to eq('penguin')
        expect(result.id).to eq(@walrus.id)
      end
    end

    context '.rename' do
      it 'renames a category' do
        result = subject.rename(@walrus.id, 'ferret')
        expect(result.name).to eq('ferret')
        expect(result.id).to eq(@walrus.id)
      end
    end
  end
end
