require 'spec_helper'
# require 'pry'
# require 'date'
#
RSpec.describe Cycad, db: true do
  include TransactionRepoHelper

  describe 'transactions' do
    let(:category) do
      Cycad.create_category('pizza').value
    end

    let(:transaction_args) do
      {
        id: 2,
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
  end
end
#
#     context 'with an existing transaction' do
#       let(:existing_transaction) do
#         Cycad::Transaction.new(
#           amount: 70,
#           date: Date.new(2017, 10, 31),
#           category_id: 'blahblahblah'
#         )
#       end
#
#       before do
#         Cycad.repo.persist_transaction(existing_transaction)
#       end
#
#       context '.remove_transaction' do
#         it 'removes an existing transaction' do
#           expect(Cycad.repo.transactions).to include(existing_transaction)
#           Cycad.remove_transaction(existing_transaction.id)
#           expect(Cycad.repo.transactions).to_not include(existing_transaction)
#         end
#       end
#
#       context '.update_transaction' do
#         it 'updates an existing transaction' do
#           Cycad.update_transaction(existing_transaction.id, amount: 8)
#           expect(Cycad.repo.find_transaction(existing_transaction.id).amount).to eq 8
#         end
#       end
#     end
#   end
#
#   context '.purge_all' do
#     context 'when there are transactions in the repo' do
#       before do
#         Cycad.repo.persist_transaction(
#           Cycad::Transaction.new(
#             date: Date.new(2017, 11, 13),
#             amount: 80,
#             category_id: 1
#           )
#         )
#       end
#
#       it 'deletes all of them' do
#         Cycad.purge_all
#         expect(Cycad.repo.count).to eq(0)
#       end
#     end
#   end
# end
