require 'spec_helper'
require 'date'

RSpec.describe Cycad::Filters::TransactionTypeFilter do
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

  context 'self.income_only' do
    it 'returns only income transactions' do
      filtered = Cycad::Filters::TransactionTypeFilter.income_only(transactions)
      expect(filtered).to contain_exactly(transaction1, transaction2)
    end
  end

  context 'self.expenses_only' do
    it 'returns only expense transactions' do
      filtered = Cycad::Filters::TransactionTypeFilter.expenses_only(transactions)
      expect(filtered).to contain_exactly(transaction3, transaction4)
    end
  end
end
