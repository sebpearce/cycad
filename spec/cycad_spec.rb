require 'spec_helper'
require 'Date'

RSpec.describe Cycad do
  context '.add_transaction' do
    let(:id) { 'id12345' }
    let(:date) { Date.new(2017, 5, 1) }
    let(:amount) { 19.95 }
    let(:category_id) { 2 }
    let(:note) { '' }

    it 'adds a new transaction' do
      transaction = Transaction.new(date: date, amount: amount, note: note, category_id: category_id)
      Cycad.add_transaction(transaction)
      expect(Cycad.repo.count).to eq(1)
      expect(transaction.id).to_not be_nil
    end
  end

  context '.find_transaction' do
    context 'with an existing transaction' do
      let!(:existing_transaction) { Transaction.new(amount: 50, date: Date.today, note: '', category_id: 0) }

      before do
        Cycad.add_transaction(existing_transaction)
      end

      it 'finds a transaction' do
        transaction = Cycad.find_transaction(existing_transaction.id)
        expect(transaction.amount).to eq(50)
      end
    end
  end
end
