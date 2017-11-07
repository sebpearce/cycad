require 'spec_helper'
require 'date'

RSpec.describe Transactions do
  let(:transaction1) do
    double(Transaction,
      date: Date.new(2017, 11, 7),
      amount: 200,
      category_id: 3
    )
  end
  let(:transaction2) do
    double(Transaction,
      date: Date.new(2017, 11, 9),
      amount: -300,
      category_id: 1
    )
  end
  let(:transaction3) do
    double(Transaction,
      date: Date.new(2017, 11, 10),
      amount: 400,
      category_id: 1
    )
  end
  let(:transaction4) do
    double(Transaction,
      date: Date.new(2017, 11, 13),
      amount: 50,
      category_id: 7
    )
  end
  let(:transaction5) do
    double(Transaction,
      date: Date.new(2017, 11, 15),
      amount: -47,
      category_id: 8
    )
  end
  let(:repo_transactions) do
    [
      transaction1,
      transaction2,
      transaction3,
      transaction4,
      transaction5
    ]
  end
  let!(:transactions) { Transactions.new(repo_transactions) }

  context '.date_range' do
    it 'returns transactions in a date range' do
      filtered = transactions.date_range(
        Date.new(2017, 11, 10),
        Date.new(2017, 11, 15)
      ).all
      expect(filtered).to contain_exactly(
        transaction3,
        transaction4,
        transaction5
      )
    end
  end

  context '.income_only' do
    it 'returns transactions with an amount greater than 0' do
      filtered = transactions.income_only.all
      expect(filtered).to contain_exactly(
        transaction1,
        transaction3,
        transaction4
      )
    end
  end

  context '.expenses_only' do
    it 'returns transactions with an amount less than 0' do
      filtered = transactions.expenses_only.all
      expect(filtered).to contain_exactly(
        transaction2,
        transaction5
      )
    end
  end

  context '.amount_range' do
    it 'returns transactions within an amount range' do
      filtered = transactions.amount_range(50, 400).all
      expect(filtered).to contain_exactly(
        transaction1,
        transaction3,
        transaction4
      )
    end
  end

  context '.greater_than' do
    it 'returns transactions with amounts greater than or equal to X' do
      filtered = transactions.greater_than(-47).all
      expect(filtered).to contain_exactly(
        transaction1,
        transaction3,
        transaction4,
        transaction5
      )
    end
  end

  context '.less_than' do
    it 'returns transactions with amounts less than or equal to X' do
      filtered = transactions.less_than(200).all
      expect(filtered).to contain_exactly(
        transaction1,
        transaction2,
        transaction4,
        transaction5
      )
    end
  end

  context '.category' do
    it 'returns only transactions of that category' do
      filtered = transactions.category(1).all
      expect(filtered).to contain_exactly(
        transaction2,
        transaction3
      )
    end
  end

  context 'when methods are chained' do
    it 'performs multiple filters on a set of transactions' do
      filtered = transactions.greater_than(-47).category(7).all
      expect(filtered).to contain_exactly(transaction4)
    end
  end
end
