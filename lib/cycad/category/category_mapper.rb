require 'cycad/category'

module Cycad
  class CategoryMapper < ROM::Mapper
    register_as :category

    model Cycad::Category

    attribute :id
    attribute :name
  end
end
