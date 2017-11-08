module Cycad
  class TransactionCategory
    attr_reader :id
    attr_accessor :name

    def initialize(name:)
      @id = id
      @name = name
    end
  end
end
