require 'securerandom'

module Cycad
  module Transaction
    class TransactionEntity
      attr_reader :id, :amount, :date, :note, :category_id, :tags

      def initialize(amount:, date:, note: nil, category_id:, tags: [])
        @amount = amount
        @date = date
        @note = note
        @category_id = category_id
        @id = SecureRandom.uuid
        @tags = tags
      end
      
      # TODO: This should be in the repo with separate methods for each thing
      def update(args)
        args.each do |key, value|
          instance_variable_set("@#{key}", value)
        end
      end

      def inspect
        to_s
      end

      def to_s
        formatted = "<#Transaction: " +
        self.instance_variables.map do |var|
          value = self.instance_variable_get("#{var}")
          "#{var} = " + (value ? value.to_s : 'nil')
        end.compact.join(", ").concat('>')
      end
    end
  end
end
