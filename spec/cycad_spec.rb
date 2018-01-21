require 'spec_helper'

RSpec.describe Cycad, db: true do
  include TransactionRepoHelper
  include CategoryRepoHelper

  describe 'transactions' do
    let(:category) do
      Cycad.create_category('pizza').value
    end

    let(:transaction_args) do
      {
        date: Date.parse('2017-5-1'),
        amount: 1995,
        category_id: category.id
      }
    end

    context '.create_transaction' do
      it 'creates a new transaction' do
        transaction = Cycad.create_transaction(transaction_args).value
        expect(find_transaction(transaction.id).amount).to eq(1995)
      end
    end

    context 'with an existing transaction' do
      let(:existing_transaction_args) do
        {
          amount: 70,
          date: Date.new(2017, 10, 31),
          category_id: category.id,
        }
      end

      let!(:existing_transaction) do
        Cycad.create_transaction(existing_transaction_args).value
      end

      context '.delete_transaction' do
        it 'deletes an existing transaction' do
          expect(find_transaction(existing_transaction.id).id).to eq(existing_transaction.id)
          Cycad.delete_transaction(existing_transaction.id)
          expect(find_transaction(existing_transaction.id)).to be_nil
        end
      end

      context '.update_transaction' do
        it 'updates an existing transaction' do
          Cycad.update_transaction(existing_transaction.id, amount: 8)
        end
      end
    end
  end

  describe 'categories' do
    context '.create_category' do
      it 'creates a new category' do
        category = Cycad.create_category('food').value
        expect(find_category(category.id).id).to eq(category.id)
      end
    end

    context 'with an existing category' do
      let!(:existing_category) do
        Cycad.create_category('trips').value
      end

      context '.rename_category' do
        it 'renames a category' do
          Cycad.rename_category(existing_category.id, 'travel')
          expect(find_category(existing_category.id).name).to eq('travel')
        end
      end

      context '.delete_category' do
        it 'deletes a category' do
          Cycad.delete_category(existing_category.id)
          expect(find_category(existing_category.id)).to be_nil
        end
      end
    end
  end
end
