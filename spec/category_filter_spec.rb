require 'spec_helper'
require 'date'

RSpec.describe Cycad::Filters::CategoryFilter do
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

  context 'self.filter_by_category' do
    it 'returns only transactions of that category' do
      filtered = Cycad::Filters::CategoryFilter.filter_by_category(transactions, 6)
      expect(filtered).to contain_exactly(transaction1, transaction2)
    end
  end
end
