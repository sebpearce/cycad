require 'spec_helper'
require 'database/config'

RSpec.describe Database::CategoryRepo, db: true do
  subject { Database::CategoryRepo.new(Database::Config::Rom) }

  before do
    @record = subject.create(name: 'test')
  end

  context '.all' do
    it 'returns an array of all categories' do
      result = subject.all
      expect(result).to be_an(Array)
      expect(result.first.name).to eq('test')
    end
  end

  context '.query' do
    it 'returns the corresponding record' do
      result = subject.query(name: 'test')
      expect(result).to be_an(Array)
      expect(result.first.name).to eq('test')
    end
  end

  context '.by_id' do
    it 'returns the corresponding record' do
      result = subject.by_id(@record.id)
      expect(result.name).to eq('test')
    end
  end

  context '.by_name' do
    it 'returns the corresponding record' do
      result = subject.by_name(@record.name)
      expect(result.name).to eq('test')
    end
  end

  context '.rename' do
    it 'renames the record' do
      result = subject.rename(@record.id, 'test2')
      expect(result.name).to eq('test2')
    end
  end
end

