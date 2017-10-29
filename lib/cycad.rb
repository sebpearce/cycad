require 'cycad/version'
require 'cycad/repo'
require 'cycad/transaction'

module Cycad
  class << self
    def repo
      @repo ||= TransactionsRepo::MemoryRepo.new
    end

    def add_transaction(transaction)
      repo.persist(transaction)
    end

    def find_transaction(id)
      repo.find(id)
    end
    
    def purge_all_transactions
      repo.purge_all
    end

    # don't like this duplicated code -
    # how can we document the keywords in the main API here
    # but still access them like regular keyword args in MemoryRepo.filter?
    def filter_transactions(date_range: nil, type: nil, category_id: nil)
      repo.filter(date_range: date_range, type: type, category_id: category_id)
    end
  end
end
