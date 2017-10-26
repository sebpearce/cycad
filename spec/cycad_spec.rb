require 'spec_helper'
require 'pry'
require 'Date'

RSpec.describe Cycad do
  context '.add_transaction' do
    it 'adds a new transaction' do
      transaction = Transaction.new(
        date: Date.new(2017, 5, 1),
        amount: 19.95,
        note: 'note',
        category_id: 2
      )
      Cycad.add_transaction(transaction)
      expect(Cycad.repo.count).to eq(1)
      expect(transaction.id).to_not be_nil
    end
  end

  context '.find_transaction' do
    context 'with an existing transaction' do
      let!(:existing_transaction) do
        Transaction.new(
          amount: 70,
          date: Date.today,
          note: '',
          category_id: 0
        )
      end

      before do
        Cycad.add_transaction(existing_transaction)
      end

      it 'finds a transaction' do
        found = Cycad.find_transaction(existing_transaction.id)
        expect(found.amount).to eq(70)
      end
    end
  end
end
