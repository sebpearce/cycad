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

bills = Cycad::Repository.for(:category).create(name: 'Bills')
parties = Cycad::Repository.for(:category).create(name: 'Parties')
puts Cycad::Repository.for(:category).all.inspect

Cycad::Repository.register(:transaction, Database::TransactionRepo.new(rom))
Cycad::Repository.for(:transaction).create(
  date: Date.new(2017, 6, 5),
  amount: 250,
  note: 'I am a note',
  category_id: bills.id
)
Cycad::Repository.for(:transaction).create(
  date: Date.new(2017, 1, 1),
  amount: 990,
  note: 'Eat cheese',
  category_id: bills.id
)
Cycad::Repository.for(:transaction).create(
  date: Date.new(2017, 4, 2),
  amount: 1000,
  category_id: parties.id,
  tags: 'blah bloop'
)

puts Cycad::Repository.for(:transaction).all.inspect
puts Cycad::Repository.for(:transaction).all.first.date
puts Cycad::Repository.for(:transaction).all.first.category_id
puts Cycad::Repository.for(:category).by_id(Cycad::Repository.for(:transaction).all.first.category_id).name

# puts Cycad::Repository.for(:category).aggregate(:transactions).one.inspect
