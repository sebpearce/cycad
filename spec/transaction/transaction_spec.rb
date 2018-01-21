require 'spec_helper'
require 'date'

RSpec.describe Cycad::Transaction do
  context '.initialize' do
    it 'adds a unique id to a new transaction' do
      new_transaction = Cycad::Transaction.new(
        id: 92,
        amount: 45,
        date: Date.new(2017, 11, 7),
        category_id: 4
      )
      expect(new_transaction.id).to_not be_nil
    end
  end
end
