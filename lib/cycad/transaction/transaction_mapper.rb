require 'cycad/transaction'

module Cycad
  class TransactionMapper < ROM::Mapper
    register_as :transaction
    relation :transactions

    model Cycad::Transaction

    attribute :id
    attribute :category_id
    attribute :amount
    attribute :date
    attribute :note
    attribute :tags
  end
end
