require 'securerandom'

module Cycad
  class Category
    attr_reader :id
    attr_accessor :name

    def initialize(id:, name:)
      @id = id
      @name = name
    end

    def rename(new_name)
      @name = new_name
    end
  end
end
