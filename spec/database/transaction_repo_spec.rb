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

  context '.income_only' do
    it 'filters records over 0' do
      subject.create(
        date: Date.new(2018, 1, 1),
        amount: -300,
        category_id: @bills.id
      )
      result = subject.income_only
      expect(result).to be_an(Array)
      expect(result.first.amount).to eq(500)
    end
  end

  context '.expenses_only' do
    it 'filters records under 0' do
      subject.create(
        date: Date.new(2018, 1, 1),
        amount: -300,
        category_id: @bills.id
      )
      result = subject.expenses_only
      expect(result).to be_an(Array)
      expect(result.first.amount).to eq(-300)
    end
  end

  context '.filter' do
    it 'filters records over a given amount' do
      result = subject.filter { amount > 5 }
      expect(result).to be_an(Array)
      expect(result.first.amount).to eq(500)
      # expect(result).to be_an(Array)
      # expect(result).to include @record
    end

    it 'filters records as an OR of two conditions' do
      result = subject.filter { (amount < 300) | (amount > 450) }
      wrong_result = subject.filter { (amount > 600) | (amount < 450) }
      expect(result).to be_an(Array)
      expect(result.first.amount).to eq(500)
      expect(wrong_result).to be_empty
    end

    it 'filters records as an AND of two conditions' do
      result = subject.filter { (date > Date.parse('2017-01-01')) && (date < Date.parse('2017-12-31')) }
      wrong_result = subject.filter { (date > Date.parse('2017-01-01')) && (date < Date.parse('2017-03-31')) }
      expect(result).to be_an(Array)
      expect(result.first.amount).to eq(500)
      expect(wrong_result).to be_empty
    end

    it 'filters records since a given date' do
      result = subject.filter { date > Date.parse('2017-01-01') }
      wrong_result = subject.filter { date > Date.parse('2017-08-01') }
      expect(result).to be_an(Array)
      expect(result.first.amount).to eq(500)
      expect(wrong_result).to be_empty
    end
  end

  context '.by_id' do
    it 'returns the corresponding record' do
      result = subject.by_id(@record.id)
      expect(result.amount).to eq(500)
    end
  end
end

