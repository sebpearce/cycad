module Cycad
  class Tagger
    def self.create_tag(name)
      Cycad::Tag.new(name)
    end

    def self.attach_tag(transaction, tag)
      transaction.tags << tag
    end

    def self.remove_tag(transaction, tag)
      transaction.tags.delete(tag)
    end
  end
end
