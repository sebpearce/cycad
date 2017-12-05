require 'securerandom'

module Cycad
  class Tag
    attr_reader :id
    attr_accessor :name

    def initialize(name)
      @id = SecureRandom.uuid
      @name = name
    end
  end
end
