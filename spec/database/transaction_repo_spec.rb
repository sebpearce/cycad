require 'spec_helper'
require 'date'
require 'database/config'

RSpec.describe Database::TransactionRepo, db: true do
  subject { Database::TransactionRepo.new(Database::Config::Rom) }

  before do
    cat_repo = Database::CategoryRepo.new(Database::Config::Rom)
    @bills = cat_repo.create(name: 'bills')
    @record = subject.create(
      date: Date.new(2017, 5, 7),
      amount: 500,
      category_id: @bills.id
    )
  end

  context '.all' do
    it 'returns an array of all categories' do
      result = subject.all
      expect(result).to be_an(Array)
      expect(result.first.amount).to eq(500)
      expect(result.first.category_id).to eq(@bills.id)
    end
  end

  context '.query' do
    it 'returns the corresponding record' do
      result = subject.query(amount: 500)
      expect(result).to be_an(Array)
      expect(result.first.amount).to eq(500)
    end
  end

  context '.by_id' do
    it 'returns the corresponding record' do
      result = subject.by_id(@record.id)
      expect(result.amount).to eq(500)
    end
  end
end

