require 'cycad/version'
require 'cycad/repo'
require 'cycad/category'
require 'cycad/transaction'
require 'cycad/transactions'
require 'cycad/tag'
require 'cycad/tagger'
require 'cycad/filters/date_filter'
require 'cycad/filters/amount_filter'
require 'cycad/filters/category_filter'
require 'cycad/validators/transaction_validator'
require 'cycad/validators/category_validator'
require 'cycad/validators/tag_validator'

# Homework 2017-11-15

# - Validations!
# - dry-validations, enforcing schemas
# - Validating the types of fields
# - Validate transaction amount is not a zero dollar amount
# - Notes for a transaction can't be longer than 255 characters
# - Category has to have a name, and has to be shorter than a specific amount
# - Tag has to have a name, and has to be shorter than a specific amount
# - Stretch goal: Hooking it up to rom-rb: [ROM](http://rom-rb.org/) and a real database

# Notes

# - We have to persist categories and tags as well.
# - In Cycad's .update_transaction, the spec only checks to see if a var on
#   the transaction has changed, but if we were using a real DB, wouldn't it
#   need to query the DB to see if the change has been persisted?
# - Is it OK to use a method from somewhere else in the before block?
#   e.g. Cycad.repo.persist_transaction(transaction1) in cycad_spec
# - I've changed Cycad's main API to take raw args now instead of instances
#   of a transaction, for example. How will this work with the web interface
#   layer? Will it just accept a JSON payload with a command and data and pipe
#   it through to the methods in cycad.rb?


module Cycad
  class << self
    def repo
      @repo ||= TransactionsRepo::MemoryRepo.new
    end

    def add_category(name)
      category = Cycad::Category.new(name)
      repo.persist_category(category)
    end

    def rename_category(id, new_name)
      category = repo.find_category(id)
      repo.rename_category(category, new_name)
    end

    def remove_category(id)
      category = repo.find_category(id)
      repo.purge_category(category)
    end

    def add_tag(name)
      tag = Cycad::Tag.new(name)
      repo.persist_tag(tag)
    end

    def rename_tag(id, new_name)
      tag = repo.find_tag(id)
      repo.rename_tag(tag, new_name)
    end

    def remove_tag(id)
      tag = repo.find_tag(id)
      repo.purge_tag(tag)
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

    def tag_transaction(transaction_id, tag_id)
      transaction = repo.find_transaction(transaction_id)
      tag = repo.find_tag(tag_id)
      Tagger.attach_tag(transaction, tag)
    end

    def untag_transaction(transaction_id, tag_id)
      transaction = repo.find_transaction(transaction_id)
      tag = repo.find_tag(tag_id)
      Tagger.remove_tag(transaction, tag)
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
