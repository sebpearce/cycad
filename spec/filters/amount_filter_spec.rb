require 'spec_helper'
require 'date'

RSpec.describe Cycad::Filters::AmountFilter do
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

  context 'self.filter_income_only' do
    it 'returns only income transactions' do
      filtered = Cycad::Filters::AmountFilter.filter_income_only(transactions)
      expect(filtered).to contain_exactly(transaction1, transaction2)
    end
  end

  context 'self.filter_expenses_only' do
    it 'returns only expense transactions' do
      filtered = Cycad::Filters::AmountFilter.filter_expenses_only(transactions)
      expect(filtered).to contain_exactly(transaction3, transaction4)
    end
  end

  context 'self.filter_amount_range' do
    let(:lower_limit) { -5 }
    let(:upper_limit) { 123 }

    it 'returns transactions within a range of amounts' do
      filtered = Cycad::Filters::AmountFilter.filter_amount_range(
        transactions,
        lower_limit,
        upper_limit
      )
      expect(filtered).to contain_exactly(transaction1, transaction2, transaction3)
    end
  end

  context 'self.filter_greater_than' do
    it 'returns transactions with amounts greater than or equal to X' do
      filtered = Cycad::Filters::AmountFilter.filter_greater_than(
        transactions,
        13
      )
      expect(filtered).to contain_exactly(transaction1, transaction2)
    end
  end

  context 'self.filter_less_than' do
    it 'returns transactions with amounts less than or equal to X' do
      filtered = Cycad::Filters::AmountFilter.filter_less_than(
        transactions,
        13
      )
      expect(filtered).to contain_exactly(transaction2, transaction3, transaction4)
    end
  end
end
