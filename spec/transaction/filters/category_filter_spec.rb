require 'spec_helper'
require 'date'

RSpec.describe Cycad::Transaction::CategoryFilter do
  let(:transaction1) { double(Cycad::Transaction, category_id: 6) }
  let(:transaction2) { double(Cycad::Transaction, category_id: 6) }
  let(:transaction3) { double(Cycad::Transaction, category_id: 9) }
  let(:transaction4) { double(Cycad::Transaction, category_id: 7) }
  let (:transactions) do
    [
      transaction1,
      transaction2,
      transaction3,
      transaction4
    ]
  end

  context 'self.filter_by_category' do
    it 'returns only transactions of that category' do
      filtered = Cycad::Transaction::CategoryFilter.filter(transactions, 6)
      expect(filtered).to contain_exactly(transaction1, transaction2)
    end
  end
end
