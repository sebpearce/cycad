require 'spec_helper'
require 'date'

RSpec.describe Cycad::Transaction::AmountFilter do
  let(:transaction1) { double(Cycad::Transaction, amount: 123) }
  let(:transaction2) { double(Cycad::Transaction, amount: 13) }
  let(:transaction3) { double(Cycad::Transaction, amount: -5) }
  let(:transaction4) { double(Cycad::Transaction, amount: -77) }
  let (:transactions) do
    [
      transaction1,
      transaction2,
      transaction3,
      transaction4
    ]
  end

  context 'self.filter' do
    it 'accepts a block and uses it to filter' do
      filtered = Cycad::Transaction::AmountFilter.filter(transactions) { |a| a < 5 }
      expect(filtered).to contain_exactly(transaction3, transaction4)
    end
  end

  context 'IncomeOnly.filter' do
    it 'returns only income transactions' do
      filtered = Cycad::Transaction::AmountFilter::IncomeOnly.filter(transactions)
      expect(filtered).to contain_exactly(transaction1, transaction2)
    end
  end

  context 'ExpensesOnly.filter' do
    it 'returns only expense transactions' do
      filtered = Cycad::Transaction::AmountFilter::ExpensesOnly.filter(transactions)
      expect(filtered).to contain_exactly(transaction3, transaction4)
    end
  end

  context 'AmountRange.filter' do
    let(:lower_limit) { -5 }
    let(:upper_limit) { 123 }

    it 'returns transactions within a range of amounts' do
      filtered = Cycad::Transaction::AmountFilter::AmountRange.filter(
        transactions,
        lower_limit,
        upper_limit
      )
      expect(filtered).to contain_exactly(transaction1, transaction2, transaction3)
    end
  end

  context 'GreaterThan.filter' do
    it 'returns transactions with amounts greater than or equal to X' do
      filtered = Cycad::Transaction::AmountFilter::GreaterThan.filter(
        transactions,
        13
      )
      expect(filtered).to contain_exactly(transaction1, transaction2)
    end
  end

  context 'LessThan.filter' do
    it 'returns transactions with amounts less than or equal to X' do
      filtered = Cycad::Transaction::AmountFilter::LessThan.filter(
        transactions,
        13
      )
      expect(filtered).to contain_exactly(transaction2, transaction3, transaction4)
    end
  end
end
