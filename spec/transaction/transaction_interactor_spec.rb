require 'spec_helper'

RSpec.describe Cycad::Transaction::Interactor do
  subject { Cycad::Transaction::Interactor }

  let(:repo) do
    double(:repo)
  end

  before do
    allow(Cycad::Repository).to receive(:for).with(:transaction).and_return(repo)
  end

  context 'self.create' do
    context 'when the input is valid' do
      let(:transaction_args) do
        {
          date: Date.new(2017, 5, 1),
          amount: 1995,
          category_id: '1337'
        }
      end

      it 'create a new transaction' do
        transaction = double(:transaction, transaction_args)
        expect(repo).to receive(:create).with(transaction_args).and_return(transaction)
        result = subject.create(transaction_args)
        expect(result.transaction).to_not be_nil
        expect(result.transaction.amount).to eq(1995)
      end
    end

    context 'when the input is invalid' do
      let(:transaction_args) do
        {
          date: '2017/5/1',
          amount: 1995,
          category_id: '1337'
        }
      end

      it 'returns an error' do
        transaction = double(:transaction, transaction_args)
        expect(repo).to_not receive(:create)
        result = subject.create(transaction_args)
        expect(result.transaction).to be_nil
        expect(result.errors).to eq({date: ['must be a date']})
      end
    end
  end

  context 'with an existing transaction' do
    let(:existing_transaction) do
      double(:transaction,
        id: 34,
        amount: 70,
        date: Date.new(2017, 10, 31),
        category_id: 'blahblahblah'
      )
    end

    context 'self.remove' do
      it 'removes an existing transaction' do
        expect(repo).to receive(:delete).with(34)
        subject.remove(existing_transaction.id)
      end
    end

    context 'self.update' do
      it 'updates an existing transaction' do
        updated_transaction = double(:transaction, amount: 8)
        expect(repo).to receive(:update).with(existing_transaction.id, amount: 8).and_return(updated_transaction)
        result = subject.update(existing_transaction.id, amount: 8)
        expect(result.transaction).to_not be_nil
        expect(result.transaction.amount).to eq(8)
      end
    end
  end
end
