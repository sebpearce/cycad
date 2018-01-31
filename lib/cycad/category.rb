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

    def inspect
      to_s
    end

    def hash
      [@id, @name].hash
    end

    def to_s
      formatted = "<#Category: " +
      self.instance_variables.map do |var|
        value = self.instance_variable_get("#{var}")
        "#{var} = " + (value ? value.to_s : 'nil')
      end.compact.join(", ").concat('>')
    end
  end
end
