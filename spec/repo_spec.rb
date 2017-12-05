require 'spec_helper'
require 'Date'

RSpec.describe Cycad::TransactionsRepo::MemoryRepo do
  let(:repo) { Cycad::TransactionsRepo::MemoryRepo.new }
  let(:transaction1) { Cycad::Transaction.new(date: Date.new(2017, 5, 1), amount: -19.95, category_id: 2 ) }
  let(:transaction2) { Cycad::Transaction.new(date: Date.new(2017, 10, 29), amount: -17, category_id: 3 ) }
  let(:transaction3) { Cycad::Transaction.new(date: Date.new(2017, 6, 1), amount: -14, category_id: 2 ) }
  let(:transaction4) { Cycad::Transaction.new(date: Date.new(2017, 5, 27), amount: -4, category_id: 2 ) }
  let(:transaction5) { Cycad::Transaction.new(date: Date.new(2017, 5, 14), amount: 4300, note: 'I am the only income transaction here', category_id: 4) }
  let(:transaction6) { Cycad::Transaction.new(date: Date.new(2017, 4, 21), amount: -5, category_id: 1 ) }
  
  describe 'transactions' do
    context '.persist_transaction' do
      let!(:persisted_transaction) { repo.persist_transaction(transaction1) }

      it 'returns the transaction that it persisted' do
        expect(persisted_transaction).to eq(transaction1)
      end

      it 'adds the transaction to the list of transactions' do
        expect(repo.transactions).to include(transaction1)
      end
    end

    context '.find_transaction' do
      before { repo.persist_transaction(transaction1) }

      it 'returns a transaction given its id' do
        expect(repo.find_transaction(transaction1.id)).to eq(transaction1)
      end
    end

    context '.update_transaction' do
      it 'updates an existing transaction' do
        repo.update_transaction(transaction1, amount: -5)
        expect(transaction1.amount).to eq(-5)
      end
    end

    context '.count'  do
      before { repo.persist_transaction(transaction1) }

      it 'returns the total number of transactions' do
        expect(repo.count).to eq(repo.transactions.count)
      end
    end

    context '.purge_transaction' do
      before { repo.persist_transaction(transaction2) }

      it 'purges a transaction' do
        repo.purge_transaction(transaction2)
        expect(repo.transactions).to_not include(transaction2)
      end
    end
  end

  describe 'categories' do
    let(:category1) { Cycad::Category.new('bills') }

    context '.persist_category' do
      it 'adds a category' do
        repo.persist_category(category1)
        expect(repo.categories).to include(category1)
      end
    end

    context '.find_category' do
      before do
        repo.persist_category(category1)
        @the_id = category1.id
      end

      it 'finds a category' do
        found = repo.find_category(@the_id)
        expect(found).to eq(category1)
      end
    end

    context '.purge_category' do
      before { repo.persist_category(category1) }

      it 'purges a category' do
        repo.purge_category(category1)
        expect(repo.categories).to_not include(category1)
      end
    end

    context '.rename_category' do
      before { repo.persist_category(category1) }

      it 'purges a category' do
        expect(category1.name).to eq('bills')
        repo.rename_category(category1, 'phone')
        expect(category1.name).to eq('phone')
      end
    end
  end

  describe 'tags' do
    let(:tag1) { Cycad::Tag.new('Birthday 2017') }

    context '.persist_tag' do
      it 'persists a tag' do
        expect(repo.tags).to_not include(tag1)
        repo.persist_tag(tag1)
        expect(repo.tags).to include(tag1)
      end
    end

    context 'with an existing tag' do
      before do
        repo.persist_tag(tag1)
      end

      context '.find_tag' do
        it 'finds a tag' do
          found = repo.find_tag(tag1.id)
          expect(found).to eq(tag1)
        end
      end

      context '.attach_tag' do
        before do
          repo.persist_transaction(transaction1)
        end

        it 'attaches a tag to a transaction' do
          repo.attach_tag(transaction1, tag1)
          expect(transaction1.tags).to include(tag1)
        end
      end

      context '.unattach_tag' do
        before do
          repo.persist_transaction(transaction1)
          repo.attach_tag(transaction1, tag1)
        end

        it 'unattaches a tag from a transaction' do
          expect(transaction1.tags).to include(tag1)
          repo.unattach_tag(transaction1, tag1)
          expect(transaction1.tags).to_not include(tag1)
        end
      end

      context '.rename_tag' do
        it 'renames a tag' do
          repo.rename_tag(tag1, 'Birthday 2018')
          expect(tag1.name).to eq('Birthday 2018')
        end
      end

      context '.purge_tag' do
        it 'purges a tag' do
          expect(repo.tags).to include(tag1)
          repo.purge_tag(tag1)
          expect(repo.tags).to_not include(tag1)
        end
      end
    end
  end

  context '.purge_all' do
    context 'when there are existing transactions' do
      before do
        repo.persist_transaction(transaction3)
        repo.persist_transaction(transaction4)
        repo.persist_transaction(transaction5)
        repo.persist_transaction(transaction6)
        repo.persist_tag(Cycad::Tag.new('blah'))
        repo.persist_category(Cycad::Category.new('car'))
      end

      it 'deletes all of them' do
        expect(repo.transactions).not_to be_empty # OK to do a pre-check?
        repo.purge_all
        expect(repo.transactions).to be_empty
        expect(repo.categories).to be_empty
        expect(repo.tags).to be_empty
      end
    end
  end
end
