module Cycad
  module InMemoryDB
    class TransactionRepo
      Transaction = Struct.new(
        :id,
        :date,
        :amount,
        :category_id,
        :note,
        :tags
      )

      attr_accessor :transactions

      def initialize
        @transactions = []
        @id = 0
      end

      def create(args)
        new_transaction = Transaction.new(
          @id,
          args[:date],
          args[:amount],
          args[:category_id],
          args[:note],
          args[:tags]
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
        # TODO basic validation here and clean up the mess below
        transaction = by_id(id)
        transaction.date = args[:date] if args[:date] != nil
        transaction.amount = args[:amount] if args[:amount] != nil
        transaction.category_id = args[:category_id] if args[:category_id] != nil
        transaction.note = args[:note] if args[:note] != nil
        transaction.tags = args[:tags] if args[:tags] != nil
        transaction
      end

      private

      def update_amount
      end

      def update_date
      end

      def update_category
      end

      def update_note
      end

      def update_tags
      end
    end
  end
end
