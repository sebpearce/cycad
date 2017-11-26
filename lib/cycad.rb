require 'cycad/version'
require 'cycad/repo'
require 'cycad/category'
require 'cycad/transaction'
require 'cycad/transactions'
require 'cycad/tag'
require 'cycad/filters/date_filter'
require 'cycad/filters/amount_filter'
require 'cycad/filters/category_filter'
require 'cycad/validators/transaction_validator'
require 'cycad/validators/category_validator'
require 'cycad/validators/tag_validator'
require 'cycad/interactors/category_interactor'
require 'cycad/interactors/tag_interactor'

# Homework 2017-11-22

# - Can you move the logic for managing categories or tags to their own
# classes? Cycad.rb is getting pretty crowded (junk drawer)

# - Think on: how the API from an external user's viewpoint would
# look like, for instance: how would a Rails controller interact with Cycad to
# add a category? Would a better method name be `Cycad.add_transaction` or
# `Cycad::Interactors::Transaction.add` or `Cycad::Actions::Transaction.add`?
# Or none of the above?
# > Yes I think that's a very good point. People outside of the gem interacting
# with it will not care how the gem is internally structured.
# `Cycad.add_transaction` therefore is probably a good entrypoint to the gem to
# use. However I wouldn't have that logic in the `Cycad` module. Working inside
# the gem would be made easier with that logic extracted out to a different
# class.

# - Create uniqueness checker classes (one for category,
# one for tag, etc) -- checks the database for existing items

# - `Cycad.add_category` returns wildly different things if the validation
# succeeds / fails. Can you make it have a common API for both cases?

# Notes



module Cycad
  class << self
    def repo
      @repo ||= TransactionsRepo::MemoryRepo.new
    end

    def add_transaction(args = {})
      transaction = Cycad::Transaction.new(args)
      repo.persist_transaction(transaction)
    end

    def remove_transaction(id)
      transaction = repo.find_transaction(id)
      repo.purge_transaction(transaction)
    end

    def update_transaction(id, args)
      transaction = repo.find_transaction(id)
      repo.update_transaction(transaction, args)
    end

    def create_category(name)
      Cycad::Interactors::Category.create(name)
    end

    def rename_category(id, new_name)
      Cycad::Interactors::Category.rename(id, new_name)
    end

    def remove_category(id)
      Cycad::Interactors::Category.remove(id)
    end

    def create_tag(name)
      Cycad::Interactors::Tag.create(name)
    end

    def rename_tag(id, new_name)
      Cycad::Interactors::Tag.rename(id, new_name)
    end

    def purge_tag(id)
      Cycad::Interactors::Tag.purge(id)
    end

    def tag_transaction(transaction_id, tag_id)
      Cycad::Interactors::Tag.attach(transaction_id, tag_id)
    end

    def untag_transaction(transaction_id, tag_id)
      Cycad::Interactors::Tag.unattach(transaction_id, tag_id)
    end

    def filter_transactions(date_range: nil, type: nil, category_id: nil)
      result = repo.transactions

      if date_range && date_range.has_key?(:start_date) && date_range.has_key?(:end_date)
        result = Filters::DateFilter::DateRange.filter(
            result,
            date_range[:start_date],
            date_range[:end_date]
          )
      end

      if type == :income_only
        result = Filters::AmountFilter::IncomeOnly.filter(result)
      elsif type == :expenses_only
        result = Filters::AmountFilter::ExpensesOnly.filter(result)
      end

      if category_id
        result = Filters::CategoryFilter.filter(result, category_id)
      end

      result
    end

    def purge_all
      repo.purge_all
    end
  end
end
