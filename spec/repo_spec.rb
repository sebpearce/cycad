require 'spec_helper'
require 'cycad/repo'
require 'cycad/transaction'
require 'Date'

RSpec.describe Cycad::TransactionsRepo::MemoryRepo do
  let(:repo) { Cycad::TransactionsRepo::MemoryRepo.new }
  let(:transaction1) { Cycad::Transaction.new(date: Date.new(2017, 5, 1), amount: -19.95, category_id: 2 ) }
  let(:transaction2) { Cycad::Transaction.new(date: Date.new(2017, 10, 29), amount: -17, category_id: 3 ) }
  let(:transaction3) { Cycad::Transaction.new(date: Date.new(2017, 6, 1), amount: -14, category_id: 2 ) }
  let(:transaction4) { Cycad::Transaction.new(date: Date.new(2017, 5, 27), amount: -4, category_id: 2 ) }
  let(:transaction5) { Cycad::Transaction.new(date: Date.new(2017, 5, 14), amount: 4300, note: 'I am the only income transaction here', category_id: 4) }
  let(:transaction6) { Cycad::Transaction.new(date: Date.new(2017, 4, 21), amount: -5, category_id: 1 ) }

  context '.persist' do
    let!(:persisted_transaction) { repo.persist(transaction1) }

    it 'returns the transaction that it persisted' do
      expect(persisted_transaction).to eq(transaction1)
    end

    it 'adds the transaction to the list of transactions' do
      expect(repo.transactions).to include(transaction1)
    end
  end

  context '.find' do
    before { repo.persist(transaction1) }

    it 'returns a transaction given its id' do
      expect(repo.find(transaction1.id)).to eq(transaction1)
    end
  end

  context '.count'  do
    before { repo.persist(transaction1) }

    it 'returns the total number of transactions' do
      expect(repo.count).to eq(repo.transactions.count)
    end
  end

  context '.purge_all' do
    context 'when there are existing transactions' do
      before do
        repo.persist(transaction3)
        repo.persist(transaction4)
        repo.persist(transaction5)
        repo.persist(transaction6)
      end

      it 'deletes all of them' do
        expect(repo.transactions).not_to be_empty # OK to do a pre-check?
        repo.purge_all
        expect(repo.transactions).to be_empty
      end
    end
  end
end
