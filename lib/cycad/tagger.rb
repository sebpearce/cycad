module Cycad
  class Tagger
    def self.create_tag(name)
      Cycad::Tag.new(name)
    end

    def self.attach_tag(transaction, tag)
      # could we make this immutable instead?
      transaction.tags << tag.id
    end

    def self.remove_tag(transaction, tag)
      transaction.tags.replace(transaction.tags - [tag.id])
      # what about this?
      # transaction.tags.delete(tag.id)
    end

    def self.update_tag_name(tag, new_name)
      tag.name = new_name
    end
  end
end
