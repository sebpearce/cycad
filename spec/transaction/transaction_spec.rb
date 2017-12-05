require 'spec_helper'
require 'date'

RSpec.describe Cycad::Transaction::TransactionEntity do
  context '.initialize' do
    it 'adds a unique id to a new transaction' do
      new_transaction = Cycad::Transaction::TransactionEntity.new(
        amount: 45,
        date: Date.new(2017, 11, 7),
        category_id: 4
      )
      expect(new_transaction.id).to_not be_nil
    end
  end

  context '.update' do
    subject do
      Cycad::Transaction::TransactionEntity.new(
        amount: 45,
        date: Date.new(2017, 11, 7),
        category_id: 4
      )
    end

    it 'updates an existing transaction' do
      subject.update(amount: -5)
      expect(subject.amount).to eq(-5)
    end
  end
end
