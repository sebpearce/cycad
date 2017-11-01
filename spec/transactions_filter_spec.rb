require 'spec_helper'
require 'date'

RSpec.describe Cycad::TransactionsFilter do
  context '.date_range' do
    let(:transaction1) { double(Transaction, date: Date.new(2017,10,5)) }
    let(:transaction2) { double(Transaction, date: Date.new(2017,10,9)) }
    let(:transaction3) { double(Transaction, date: Date.new(2017,10,15)) }
    let(:transaction4) { double(Transaction, date: Date.new(2017,10,25)) }

    let (:transactions) do
      [
        transaction1,
        transaction2,
        transaction3,
        transaction4
      ]
    end

    it 'finds transactions in a date range' do
      filtered = Cycad::TransactionsFilter.date_range(transactions, Date.new(2017,10,5), Date.new(2017,10,15))
      expect(filtered).to contain_exactly(transaction1, transaction2, transaction3)
    end
  end

  context '.income_only' do
    let(:transaction1) { double(Transaction, amount: 123) }
    let(:transaction2) { double(Transaction, amount: 13) }
    let(:transaction3) { double(Transaction, amount: -5) }
    let(:transaction4) { double(Transaction, amount: -77) }
    let (:transactions) do
      [
        transaction1,
        transaction2,
        transaction3,
        transaction4
      ]
    end

    it 'returns only income transactions' do
      filtered = Cycad::TransactionsFilter.income_only(transactions)
      expect(filtered).to contain_exactly(transaction1, transaction2)
    end
  end

  context '.expenses_only' do
    let(:transaction1) { double(Transaction, amount: 123) }
    let(:transaction2) { double(Transaction, amount: 13) }
    let(:transaction3) { double(Transaction, amount: -5) }
    let(:transaction4) { double(Transaction, amount: -77) }
    let (:transactions) do
      [
        transaction1,
        transaction2,
        transaction3,
        transaction4
      ]
    end

    it 'returns only expense transactions' do
      filtered = Cycad::TransactionsFilter.expenses_only(transactions)
      expect(filtered).to contain_exactly(transaction3, transaction4)
    end
  end

  context '.category_filter' do
    let(:transaction1) { double(Transaction, category_id: 6) }
    let(:transaction2) { double(Transaction, category_id: 6) }
    let(:transaction3) { double(Transaction, category_id: 9) }
    let(:transaction4) { double(Transaction, category_id: 7) }
    let (:transactions) do
      [
        transaction1,
        transaction2,
        transaction3,
        transaction4
      ]
    end

    it 'returns only transactions of that category' do
      filtered = Cycad::TransactionsFilter.category_filter(transactions, 6)
      expect(filtered).to contain_exactly(transaction1, transaction2)
    end
  end
end
