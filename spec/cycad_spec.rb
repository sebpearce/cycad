require 'spec_helper'
require 'pry'
require 'date'

RSpec.describe Cycad do
  context '.add_transaction' do
    it 'adds a new transaction' do
      transaction = Cycad::Transaction.new(
        date: Date.new(2017, 5, 1),
        amount: 19.95,
        category_id: 2
      )
      Cycad.add_transaction(transaction)
      expect(Cycad.repo.transactions).to include(transaction)
      expect(transaction.id).to_not be_nil
    end
  end

  context '.remove_transaction' do
    let(:transaction) do
      Cycad::Transaction.new(
        date: Date.new(2017, 11, 14),
        amount: 5,
        category_id: 1
      )
    end

    before { Cycad.add_transaction(transaction) }

    it 'removes an existing transaction' do
      Cycad.remove_transaction(transaction)
      expect(Cycad.repo.transactions).to_not include(transaction)
    end
  end

  context '.tag_transaction' do
    it 'adds an existing tag to a transaction' do
      transaction = Cycad::Transaction.new(
        date: Date.new(2017, 8, 4),
        amount: 77,
        category_id: 2
      )
      tag = Cycad::Tag.new('Xmas 2017')
      Cycad.tag_transaction(transaction, tag)
      expect(transaction.tags).to contain_exactly(tag.id)
    end
  end

  context '.purge_all_transactions' do
    context 'when there are transactions in the repo' do
      before do
        Cycad.add_transaction(
          Cycad::Transaction.new(
            date: Date.new(2017, 11, 13),
            amount: 80,
            category_id: 1
          )
        )
      end

      it 'deletes all of them' do
        Cycad.purge_all_transactions
        expect(Cycad.repo.count).to eq(0)
      end
    end
  end

  context '.find_transaction' do
    context 'with an existing transaction' do
      let!(:existing_transaction) do
        Cycad::Transaction.new(
          amount: 70,
          date: Date.today,
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

  context '.filter_transactions' do
    let(:transaction1) { Cycad::Transaction.new(amount: 3, date: Date.new(2010, 9, 1), category_id: 1) }
    let(:transaction2) { Cycad::Transaction.new(amount: 13, date: Date.new(2017, 9, 5), category_id: 1) }
    let(:transaction3) { Cycad::Transaction.new(amount: 52, date: Date.new(2017, 10, 5), category_id: 1) }
    let(:transaction4) { Cycad::Transaction.new(amount: 99, date: Date.new(2017, 10, 15), category_id: 2) }
    let(:transaction5) { Cycad::Transaction.new(amount: 4000, date: Date.new(2017, 10, 3), category_id: 3) }
    let!(:all_transactions) do
      [transaction1, transaction2, transaction3, transaction4, transaction5]
    end

    before do
      Cycad.add_transaction(transaction1)
      Cycad.add_transaction(transaction2)
      Cycad.add_transaction(transaction3)
      Cycad.add_transaction(transaction4)
      Cycad.add_transaction(transaction5)
    end

    context 'when no arguments are provided' do
      it 'returns all transactions' do
        expect(Cycad.filter_transactions).to eq(all_transactions)
      end
    end

    context 'when a date range and category is provided' do
      subject do
        Cycad.filter_transactions(
          date_range: {
            start_date: Date.new(2016),
            end_date: Date.new(2018)
          },
          category_id: 1
        )
      end

      it 'returns transactions that match that range and category' do
        is_expected.to eq([transaction2, transaction3])
      end
    end
  end
end
