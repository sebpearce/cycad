module Database
  module Relations
    class Transactions < ROM::Relation[:sql]
      struct_namespace Cycad
      schema(:transactions) do
        attribute :id, ROM::Types::Int
        attribute :category_id, ROM::SQL::Types::ForeignKey(:categories, ROM::Types::String)
        attribute :amount, ROM::Types::Int
        attribute :date, ROM::Types::Date
        attribute :note, ROM::Types::String
        attribute :tags, ROM::Types::String

        primary_key :id

        associations do
          belongs_to :category
        end
      end
    end
  end
end
