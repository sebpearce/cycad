require 'securerandom'

module Cycad
  class Transaction
    attr_reader :id, :amount, :date, :note, :category_id, :tags

    def initialize(id:, amount:, date:, note: nil, category_id:, tags: [])
      @id = id
      @amount = amount
      @date = date
      @note = note
      @category_id = category_id
      @tags = tags
    end

    def inspect
      to_s
    end

    def hash
      [@id, @amount, @date, @note, @category_id, @tags].hash
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
