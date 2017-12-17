module Database
  class MemoryRepo
    attr_accessor :transactions, :categories

    def initialize
      @transactions = []
      @categories = []
    end

    def persist_transaction(transaction)
      transactions << transaction
      transaction
    end

    def find_transaction(id)
      transactions.find { |transaction| transaction.id == id }
    end

    def update_transaction(transaction, args = {})
      transaction.update(args)
    end

    def count
      transactions.count
    end

    def purge_transaction(transaction)
      transactions.delete(transaction)
    end

    def persist_category(category)
      categories << category
      category
    end

    def find_category(id)
      categories.find { |category| category.id == id }
    end

    def rename_category(category, new_name)
      category.rename(new_name)
    end

    def purge_category(category)
      categories.delete(category)
    end

    def purge_all
      @transactions = []
      @categories = []
    end
  end
end
