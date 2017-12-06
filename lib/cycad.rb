require 'cycad/version'
require 'cycad/repo'
require 'cycad/interactor_base'
require 'cycad/category'
require 'cycad/category/category_interactor'
require 'cycad/category/category_validator'
require 'cycad/tag'
require 'cycad/tag/tag_interactor'
require 'cycad/tag/tag_validator'
require 'cycad/transaction'
require 'cycad/transaction/transaction_interactor'
require 'cycad/transaction/transaction_validator'
require 'cycad/transaction/filters/date_filter'
require 'cycad/transaction/filters/amount_filter'
require 'cycad/transaction/filters/category_filter'
require 'cycad/transactions'

# Homework 2017-11-29

# - Create uniqueness checker classes (one for category, one for tag, etc) -- checks the database for existing items
# - [dry-rb - dry-validation - Comparison With ActiveModel](http://dry-rb.org/gems/dry-validation/comparison-with-activemodel/) - Section 2.11 uniqueness validator
# - `schema.with(repo: repo).call(input)`
  # - Cautious about injecting entire repo, can you inject just a CategoryUniquenessValidator that encapsulated uniqueness logic? It should only have one method to validate the category's uniqueness.
  # - Possibly initialized like `CategoryUniquenessValidator.new(repo).unique?(name)`

# Notes
# - One site said: repository layer should NOT update/save stuff, it's just a collection of objects in memory. updates should happen in the interactors.
# - rename "find" method to "get" ("find" should take a predicate; ie it's a filter)
# - Does it make sense to return an "EditResult" with the tag/transaction/category in it on a rename, as I've done? Or just a create?

# "Basically, whenever you have to work with several objects of the same type, you should consider introducing a Repository for them. Repositories are specialized by object type and not general. So for a blog application, you may have distinct repositories for blog posts, for comments, for users, for user configurations, for themes, for designs, for or anything you may have multiple instances of." (https://code.tutsplus.com/tutorials/the-repository-design-pattern--net-35804)
# - (https://8thlight.com/blog/mike-ebert/2013/03/23/the-repository-pattern.html)

# At Braintree, we're using a new convention for new projects. Our domain objects do not contain any persistence logic. Instead, we've introduced a repository layer which is in charge of the persistence of these domain objects. This pattern is well-documented in Domain Driven Design.  Introducing a Repository layer into our applications has a number of benefits. The main benefit is that it separates out different kinds of logic. Domain logic goes into the domain objects, and can be tested in isolation without any persistence. Persistence logic goes into the repository objects, which only deal with saving and retrieving objects.
#                                         ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
# (https://www.braintreepayments.com/blog/untangle-domain-and-persistence-logic-with-curator/)
#
# When a class inherits from Hanami::Repository, it will receive the following interface:
# create(data) – Create a record for the given data (or entity)
# update(id, data) – Update the record corresponding to the given id by setting the given data (or entity)
# delete(id) – Delete the record corresponding to the given id
# all - Fetch all the entities from the relation
# find - Fetch an entity from the relation by primary key
# first - Fetch the first entity from the relation
# last - Fetch the last entity from the relation
# clear - Delete all the records from the relation
# (https://github.com/hanami/model)

# Notes from session
# The repo shouldn't know about the objects, just the ID/attributes. So the update method should take an id and attributes, not a transaction and attributes.
# The interactor tells the Tag to mutate itself (the in-memory domain object) and then tells the repo to persist the new attributes to the corresponding record.


module Cycad
  class << self
    def repo
      @repo ||= TransactionsRepo::MemoryRepo.new
    end

    def create_transaction(args = {})
      Cycad::Transaction::Interactor.create(args)
    end

    def remove_transaction(id)
      Cycad::Transaction::Interactor.remove(id)
    end

    def update_transaction(id, args)
      Cycad::Transaction::Interactor.update(id, args)
    end

    def create_category(name)
      Cycad::Category::Interactor.create(name)
    end

    def rename_category(id, new_name)
      Cycad::Category::Interactor.rename(id, new_name)
    end

    def remove_category(id)
      Cycad::Category::Interactor.remove(id)
    end

    def create_tag(name)
      Cycad::Tag::Interactor.create(name)
    end

    def rename_tag(id, new_name)
      Cycad::Tag::Interactor.rename(id, new_name)
    end

    def purge_tag(id)
      Cycad::Tag::Interactor.purge(id)
    end

    def tag_transaction(transaction_id, tag_id)
      Cycad::Tag::Interactor.attach(transaction_id, tag_id)
    end

    def untag_transaction(transaction_id, tag_id)
      Cycad::Tag::Interactor.unattach(transaction_id, tag_id)
    end

    def purge_all
      repo.purge_all
    end
  end
end
