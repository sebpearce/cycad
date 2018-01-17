module TransactionRepoHelper
  def find_transaction(id)
    Cycad::Repository.for(:transaction).by_id(id)
  end
end
