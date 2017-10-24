require 'spec_helper'
require 'Date'

RSpec.describe Cycad do
  describe Cycad, '.add_transaction' do
    let(:id) { 'id12345' }
    let(:date) { Date.new(2017, 5, 1) }
    let(:amt) { 19.95 }
    let(:cat_id) { 2 }

    it 'adds a new transaction' do
      expect(Cycad.add_transaction(id: id,
                                   date: date,
                                   amt: amt,
                                   cat_id: cat_id)).to eq('foo')
    end
  end
end
