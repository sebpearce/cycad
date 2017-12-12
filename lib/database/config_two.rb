require 'date'
require 'rom'
require 'rom-repository'

rom = ROM.container(:sql, 'sqlite::memory') do |conf|
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
      attribute :id, ROM::SQL::Types::Int
      attribute :name, ROM::SQL::Types::String

      associations do
        has_many :transactions
      end
    end
  end

  conf.relation(:transactions) do
    schema do
      attribute :id, ROM::SQL::Types::Int
      attribute :category_id, ROM::SQL::Types::Int
      attribute :amount, ROM::SQL::Types::Int
      attribute :date, ROM::SQL::Types::Date
      attribute :note, ROM::SQL::Types::String
      attribute :tags, ROM::SQL::Types::String

      associations do
        belongs_to :category
      end
    end
  end
end

category_repo = Database::CategoryRepo.new(rom)
category_repo.create(name: 'Bills')
category_repo.create(name: 'Parties')
puts category_repo.all.inspect

transaction_repo = Database::TransactionRepo.new(rom)
transaction_repo.create(
  date: Date.new(2017, 6, 5),
  amount: 250,
  note: 'I am a note',
  category_id: 1
)
transaction_repo.create(
  date: Date.new(2017, 1, 1),
  amount: 990,
  note: 'Eat cheese',
  category_id: 1
)
transaction_repo.create(
  date: Date.new(2017, 4, 2),
  amount: 1000,
  category_id: 2,
  tags: 'blah'
)

puts transaction_repo.all.inspect
# puts category_repo.aggregate(:transactions).one.inspect
