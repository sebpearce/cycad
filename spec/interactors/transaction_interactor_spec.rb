require 'spec_helper'

RSpec.describe Cycad::Interactors::Transaction do
  context 'self.add' do
    let(:transaction_args) do
      {
        date: Date.new(2017, 5, 1),
        amount: 19.95,
        category_id: '1337'
      }
    end

    it 'adds a new transaction' do
      Cycad::Interactors::Transaction.add(transaction_args)
      expect(Cycad.repo.transactions.first.amount).to eq(19.95)
    end
  end

  context 'with an existing transaction' do
    let!(:existing_transaction) do
      Cycad::Transaction.new(
        amount: 70,
        date: Date.new(2017, 10, 31),
        category_id: 'blahblahblah'
      )
    end

    before do
      Cycad.repo.persist_transaction(existing_transaction)
    end

    context 'self.remove' do
      it 'removes an existing transaction' do
        expect(Cycad.repo.transactions).to include(existing_transaction)
        Cycad::Interactors::Transaction.remove(existing_transaction.id)
        expect(Cycad.repo.transactions).to_not include(existing_transaction)
      end
    end

    context 'self.update' do
      it 'updates an existing transaction' do
        Cycad::Interactors::Transaction.update(existing_transaction.id, amount: 8)
        expect(Cycad.repo.find_transaction(existing_transaction.id).amount).to eq 8
      end
    end
  end
end
