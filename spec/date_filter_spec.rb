require 'spec_helper'
require 'date'

RSpec.describe Cycad::Filters::DateFilter do
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

  context 'self.filter_by_date_range' do
    it 'finds transactions in a date range' do
      filtered = Cycad::Filters::DateFilter.filter_by_date_range(
        transactions,
        Date.new(2017,10,5),
        Date.new(2017,10,15)
      )
      expect(filtered).to contain_exactly(transaction1, transaction2, transaction3)
    end
  end
end
