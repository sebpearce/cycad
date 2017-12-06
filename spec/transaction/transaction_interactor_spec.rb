require 'spec_helper'

RSpec.describe Cycad::Transaction::Interactor do
  subject { Cycad::Transaction::Interactor }

  context 'self.create' do
    let(:transaction_args) do
      {
        date: Date.new(2017, 5, 1),
        amount: 1995,
        category_id: '1337'
      }
    end

    it 'create a new transaction' do
      result = subject.create(transaction_args)
      expect(result.transaction).to_not be_nil
      expect(result.transaction.amount).to eq 1995
      expect(Cycad.repo.transactions.first.amount).to eq 1995
    end
  end

  context 'with an existing transaction' do
    let(:existing_transaction) do
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
        subject.remove(existing_transaction.id)
        expect(Cycad.repo.transactions).to_not include(existing_transaction)
      end
    end

    context 'self.update' do
      it 'updates an existing transaction' do
        result = subject.update(existing_transaction.id, amount: 8)
        expect(result.transaction).to_not be_nil
        expect(result.transaction.amount).to eq 8
        expect(Cycad.repo.find_transaction(existing_transaction.id).amount).to eq 8
      end
    end
  end
end
