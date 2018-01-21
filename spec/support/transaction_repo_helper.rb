module TransactionRepoHelper
  def find_transaction(id)
    Cycad::Repository.for(:transaction).by_id(id)
  end

  def all_transactions
    Cycad::Repository.for(:transactions).all
  end
end
