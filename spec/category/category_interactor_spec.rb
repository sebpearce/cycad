require 'spec_helper'

RSpec.describe Cycad::Category::Interactor do
  subject { Cycad::Category::Interactor }

  let(:repo) do
    double(:repo)
  end

  before do
    allow(Cycad::Repository).to receive(:for).with(:category).and_return(repo)
  end

  context 'self.create' do
    context 'when the category name is valid' do
      it 'creates a category' do
        category = double(:category, name: 'uni')
        expect(repo).to receive(:create).with({name: 'uni'}).and_return(category)
        result = subject.create('uni')
        expect(result.category).to_not be_nil
        expect(result.category.name).to eq('uni')
      end
    end

    context 'when the category name is invalid' do
      it 'returns an error' do
        result = subject.create('')
        expect(result.category).to be_nil
        expect(result.errors).to eq({name: ['must be filled']})
      end
    end
  end

  context 'self.rename' do
    context 'when the category name is valid' do
      it 'renames a category' do
        category = double(:category, name: 'uni', id: 'im_an_id')
        renamed_category = double(:category, name: 'NEW_NAME')
        expect(repo).to receive(:rename).with(category.id, 'NEW_NAME').and_return(renamed_category)
        result = subject.rename(category.id, 'NEW_NAME')
        expect(result.category).to_not be_nil
        expect(result.category.name).to eq('NEW_NAME')
      end
    end

    context 'when the category name is invalid' do
      it 'returns an error' do
        result = subject.rename(@the_id, '')
        expect(result.category).to be_nil
        expect(result.errors).to eq({name: ['must be filled']})
      end
    end
  end

  context 'self.remove' do
    it 'removes a category' do
      expect(repo).to receive(:delete).with('im_an_id')
      subject.remove('im_an_id')
    end
  end
end
