require 'spec_helper'
require 'cycad/repo'
require 'cycad/transaction'
require 'Date'

RSpec.describe TransactionsRepo::MemoryRepo do
  let(:repo) { TransactionsRepo::MemoryRepo.new }
  let(:transaction1) { Transaction.new(date: Date.new(2017, 5, 1), amount: -19.95, category_id: 2 ) }
  let(:transaction2) { Transaction.new(date: Date.new(2017, 10, 29), amount: -17, category_id: 3 ) }
  let(:transaction3) { Transaction.new(date: Date.new(2017, 6, 1), amount: -14, category_id: 2 ) }
  let(:transaction4) { Transaction.new(date: Date.new(2017, 5, 27), amount: -4, category_id: 2 ) }
  let(:transaction5) { Transaction.new(date: Date.new(2017, 5, 14), amount: 4300, note: 'I am the only income transaction here', category_id: 4) }
  let(:transaction6) { Transaction.new(date: Date.new(2017, 4, 21), amount: -5, category_id: 1 ) }

  context '.persist' do
    before { @returned = repo.persist(transaction1) }

    it 'returns the transaction that it persisted' do
      expect(@returned).to eq(transaction1)
    end

    it 'adds a unique id to each transaction' do
      repo.persist(transaction2)
      expect(transaction1.id).to_not eq(transaction2.id)
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

  context '.filter' do
    before do
      repo.persist(transaction3)
      repo.persist(transaction4)
      repo.persist(transaction5)
      repo.persist(transaction6)
    end

    context 'when a date range is provided' do
      subject { repo.filter(filter_args) }

      context 'when the start date is missing' do
        let(:filter_args) do
          {
            date_range: {
              end_date: Date.new(2017,5,31)
            }
          }
        end
        
        it 'raises an ArgumentError' do
          expect { subject }.to raise_error(ArgumentError)
        end
      end

      context 'when the end date is missing' do
        let(:filter_args) do
          {
            date_range: {
              start_date: Date.new(2017,5,1)
            }
          }
        end

        it 'raises an ArgumentError' do
          expect { subject }.to raise_error(ArgumentError)
        end
      end

      context 'when the date range is empty' do
        let(:filter_args) { {date_range: {}} }

        it 'raises an ArgumentError' do
          expect { subject }.to raise_error(ArgumentError)
        end
      end

      context 'when the date range is the correct format' do
        let(:filter_args) do
          {
            date_range: {
              start_date: Date.new(2017,5,1),
              end_date: Date.new(2017,5,31)
            }
          }
        end

        it 'returns all transactions within the range and none outside it' do
          is_expected.to include(transaction4)
          is_expected.to include(transaction5)
          is_expected.to_not include(transaction3)
          is_expected.to_not include(transaction6)
        end
      end

      # What about when they pass in something that's not a date?
    end

    context 'when a transaction type is provided' do
      subject { repo.filter(filter_args) }

      context 'when the type is neither :income nor :expense' do
        let(:filter_args) { {type: :walrus} }

        it 'raises an ArgumentError' do
          expect { subject }.to raise_error(ArgumentError)
        end
      end

      context 'when the type is :income' do
        let(:filter_args) { {type: :income} }

        it 'returns only income transactions' do
          is_expected.to eq([transaction5])
        end
      end

      context 'when the type is :expense' do
        let(:filter_args) { {type: :expense} }

        it 'returns only expense transactions' do
          is_expected.to include(transaction3)
          is_expected.to include(transaction4)
          is_expected.to include(transaction6)
          is_expected.to_not include(transaction5)
        end
      end
    end

    context 'when a category is provided' do
      subject { repo.filter(filter_args) }
      
      context 'when the category is not a number' do
        let(:filter_args) { {category_id: 'muffin'} }

        it 'raises an ArgumentError' do
          expect { subject }.to raise_error(ArgumentError)
        end
      end

      context 'when the category matches certain transactions' do
        let(:filter_args) { {category_id: 2} }

        it 'returns the transactions' do
          is_expected.to eq([transaction3, transaction4])
        end
      end
    end
  end
end
