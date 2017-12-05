require 'securerandom'

module Cycad
  module Tag
    class TagEntity
      attr_reader :id
      attr_accessor :name

      def initialize(name)
        @id = SecureRandom.uuid
        @name = name
      end
    end
  end
end
