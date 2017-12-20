require 'ostruct'

module Cycad
  module InMemoryDB
    class TransactionRepo
      class Transaction
        attr_reader :id
        attr_accessor :date, :amount, :category_id, :note, :tags

        def initialize(id:, date:, amount:, category_id:, note: nil, tags: nil)
          @id = id
          @date = date
          @amount = amount
          @category_id = category_id
          @note = note
          @tags = tags
        end
      end

      attr_accessor :transactions

      def initialize
        @transactions = []
        @id = 0
      end

      def create(date:, amount:, category_id:, note: nil, tags: nil)
        new_transaction = Transaction.new(
          id: @id,
          date: date,
          amount: amount,
          category_id: category_id,
          note: note,
          tags: tags
        )
        @transactions << new_transaction
        @id += 1
        new_transaction
      end

      def by_id(id)
        transactions.find { |transaction| transaction.id == id }
      end

      def all
        transactions
      end

      def delete(id)
        transaction = by_id(id)
        transactions.delete(transaction)
      end

      def update(id, args)
        transaction = by_id(id)
        [:date, :amount, :category_id, :note, :tags].each do |attr|
          transaction.send("#{attr}=", args[attr]) if args[attr]
        end
        transaction
      end
    end
  end
end
