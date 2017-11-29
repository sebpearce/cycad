require 'spec_helper'
require 'pry'
require 'date'

RSpec.describe Cycad do
  describe 'transactions' do
    let(:transaction_args) do
      {
        date: Date.new(2017, 5, 1),
        amount: 19.95,
        category_id: '1337'
      }
    end

    context '.add_transaction' do
      it 'adds a new transaction' do
        Cycad.add_transaction(transaction_args)
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

      context '.remove_transaction' do
        it 'removes an existing transaction' do
          expect(Cycad.repo.transactions).to include(existing_transaction)
          Cycad.remove_transaction(existing_transaction.id)
          expect(Cycad.repo.transactions).to_not include(existing_transaction)
        end
      end

      context '.update_transaction' do
        it 'updates an existing transaction' do
          Cycad.update_transaction(existing_transaction.id, amount: 8)
          expect(Cycad.repo.find_transaction(existing_transaction.id).amount).to eq 8
        end
      end

      context '.tag_transaction' do
        let(:tag) { Cycad::Tag.new('Xmas 2017') }

        before { Cycad.repo.persist_tag(tag) }

        it 'adds an existing tag to a transaction' do
          Cycad.tag_transaction(existing_transaction.id, tag.id)
          expect(existing_transaction.tags).to contain_exactly(tag)
        end
      end

      context '.untag_transaction' do
        let(:tag) { Cycad::Tag.new('Xmas 2017') }

        before do
          Cycad.repo.persist_tag(tag)
          Cycad.tag_transaction(existing_transaction.id, tag.id)
        end

        it 'adds an existing tag to a transaction' do
          expect(existing_transaction.tags).to contain_exactly(tag)
          Cycad.untag_transaction(existing_transaction.id, tag.id)
          expect(existing_transaction.tags).to_not include(tag)
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
        Cycad.repo.persist_transaction(transaction1)
        Cycad.repo.persist_transaction(transaction2)
        Cycad.repo.persist_transaction(transaction3)
        Cycad.repo.persist_transaction(transaction4)
        Cycad.repo.persist_transaction(transaction5)
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

  describe 'tags' do
    context '.create_tag' do
      it 'creates a tag' do
        Cycad.create_tag('Cliff’s birthday')
        expect(Cycad.repo.tags.first.name).to eq('Cliff’s birthday')
      end
    end

    context '.rename_tag' do
      before do
        existing_tag = Cycad.create_tag('food')
        @the_id = existing_tag.id
      end

      it 'renames a tag' do
        expect(Cycad.repo.tags.first.name).to eq('food')
        Cycad.rename_tag(@the_id, 'NEW_NAME')
        expect(Cycad.repo.tags.first.name).to eq('NEW_NAME')
      end
    end

    context '.purge_tag' do
      before do
        @tag2 = Cycad.create_tag('pizza')
      end

      it 'removes a tag' do
        expect(Cycad.repo.tags).to include(@tag2)
        Cycad.purge_tag(@tag2.id)
        expect(Cycad.repo.tags).to_not include(@tag2)
      end
    end
  end

  context '.purge_all' do
    context 'when there are transactions in the repo' do
      before do
        Cycad.repo.persist_transaction(
          Cycad::Transaction.new(
            date: Date.new(2017, 11, 13),
            amount: 80,
            category_id: 1
          )
        )
      end

      it 'deletes all of them' do
        Cycad.purge_all
        expect(Cycad.repo.count).to eq(0)
      end
    end
  end
end
