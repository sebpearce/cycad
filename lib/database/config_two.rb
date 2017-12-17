require 'date'
require 'rom'
require 'rom-repository'
require 'securerandom'

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
end

Cycad::Repository.register(:category, Database::CategoryRepo.new(rom))

Cycad::Repository.for(:category).create(name: 'Bills')
Cycad::Repository.for(:category).create(name: 'Parties')
puts Cycad::Repository.for(:category).all.inspect

transaction_repo = Database::TransactionRepo.new(rom)
transaction_repo.create(
  date: Date.new(2017, 6, 5),
  amount: 250,
  note: 'I am a note',
  category_id: Cycad::Repository.for(:category).query(name: 'Bills').first.id
)
transaction_repo.create(
  date: Date.new(2017, 1, 1),
  amount: 990,
  note: 'Eat cheese',
  category_id: Cycad::Repository.for(:category).query(name: 'Parties').first.id
)
transaction_repo.create(
  date: Date.new(2017, 4, 2),
  amount: 1000,
  category_id: Cycad::Repository.for(:category).query(name: 'Parties').first.id,
  tags: 'blah'
)

puts transaction_repo.all.inspect
puts transaction_repo.all.first.date
puts transaction_repo.all.first.category_id
puts Cycad::Repository.for(:category).by_id(transaction_repo.all.first.category_id).name

# puts Cycad::Repository.for(:category).aggregate(:transactions).one.inspect
