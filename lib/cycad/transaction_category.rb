require 'securerandom'

module Cycad
  class TransactionCategory
    attr_reader :id, :name

    def initialize(name:)
      @id = SecureRandom.uuid
      @name = name
    end
  end
end
