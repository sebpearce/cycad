module Database
  module Relations
    class Categories < ROM::Relation[:sql]
      schema(:categories) do
        attribute :id, ROM::Types::Int
        attribute :name, ROM::Types::String

        primary_key :id

        associations do
          has_many :transactions
        end
      end
    end
  end
end
