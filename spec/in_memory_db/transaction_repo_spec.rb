require 'spec_helper'
require 'date'

RSpec.describe Cycad::InMemoryDB::TransactionRepo do
  subject { Cycad::InMemoryDB::TransactionRepo.new }

  context '.create' do
    it 'creates a transaction' do
      subject.create(
        date: Date.new(2017, 7, 4),
        amount: 450,
        category_id: 2
      )
      expect(subject.transactions.first.amount).to eq(450)
    end
  end

  context 'with existing transactions' do
    before do
      @transaction1 = subject.create(
        date: Date.new(2017, 7, 4),
        amount: 450,
        category_id: 2
      )
      @transaction2 = subject.create(
        date: Date.new(2017, 8, 5),
        amount: 1000,
        category_id: 1
      )
    end

    context '.by_id' do
      it 'returns the corresponding transaction' do
        result = subject.by_id(@transaction1.id)
        expect(result.amount).to eq(450)
      end
    end

    context '.all' do
      it 'returns an array of all transactions' do
        result = subject.all
        expect(result).to include(@transaction1, @transaction2)
      end
    end

    context '.delete' do
      it 'deletes a transaction' do
        subject.delete(@transaction1.id)
        expect(subject.transactions).to_not include(@transaction1)
      end
    end

    context '.update' do
      it 'updates a transaction' do
        result = subject.update(@transaction1.id, amount: 7000)
        expect(result.amount).to eq(7000)
        expect(result.id).to eq(@transaction1.id)
      end
    end

    context '.update_amount' do
    end

    context '.update_date' do
    end

    context '.update_category' do
    end

    context '.update_note' do
    end

    context '.update_tags' do
    end
  end
end
