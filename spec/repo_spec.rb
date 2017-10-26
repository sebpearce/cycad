require 'spec_helper'
require 'cycad/repo'
require 'cycad/transaction'
require 'Date'

RSpec.describe TransactionsRepo::MemoryRepo do
  let(:repo) { TransactionsRepo::MemoryRepo.new }
  let(:transaction) do
    Transaction.new(
      date: Date.new(2017, 5, 1),
      amount: 19.95,
      note: 'NOTE',
      category_id: 2
    )
  end

  before do
    @returned = repo.persist(transaction)
  end

  context '.persist' do
    it 'returns the transaction that it persisted' do
      expect(@returned).to eq(transaction)
    end

    it 'adds a unique id to each transaction' do
      second_transaction = Transaction.new(
        date: Date.today,
        amount: 17,
        note: 'blah',
        category_id: 3
      )
      repo.persist(second_transaction)
      expect(transaction.id).to_not eq(second_transaction.id)
    end

    it 'adds the transaction to the list of transactions' do
      expect(repo.transactions).to include(transaction)
    end
  end

  context '.find' do
    it 'returns a transaction given its id' do
      expect(repo.find(transaction.id)).to eq(transaction)
    end
  end

  context '.count'  do
    it 'returns the total number of transactions' do
      expect(repo.count).to eq(repo.transactions.count)
    end
  end
end
