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

  context '.unique?' do
    context 'when category is not unique' do
      it 'returns false' do
        result = subject.unique?('test')
        expect(result).to eq(false)
      end
    end

    context 'when category is unique' do
      it 'returns true' do
        result = subject.unique?('testxyz')
        expect(result).to eq(true)
      end
    end
  end
end

