require 'date'
require 'rom'
require 'rom-repository'
require 'securerandom'
require 'cycad/category/category_mapper'

module Database
  class Config
    Rom = ROM.container(:sql, 'sqlite::memory') do |conf|
      conf.default.create_table(:categories) do
        primary_key :id
        column :name, String, null: false
      end

      conf.default.create_table(:transactions) do
        # primary_key is a shortcut for the annotation: Types::Int.meta(primary_key: true)
        primary_key :id
        foreign_key :category_id, :categories, null: false
        column :amount, Integer, null: false
        column :date, Date, null: false
        column :note, String
        column :tags, String
      end

      conf.relation(:categories) do
        schema do
          attribute :id, ROM::Types::Int
          attribute :name, ROM::Types::String

          primary_key :id

          associations do
            has_many :transactions
          end
        end
      end

      conf.relation(:transactions) do
        schema do
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

      conf.register_mapper(Cycad::CategoryMapper)
    end
  end
end
