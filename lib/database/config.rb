require 'rom'
require 'rom-sql'
require 'date'

rom = ROM.container(:sql, 'sqlite::memory') do |config|
  config.default.create_table(:categories) do
    # primary_key :id, String, auto
    column :id, String, null: false
    column :name, String, null: false
  end
  
  config.default.create_table(:tags) do
    primary_key :id
    column :name, String, null: false
  end

  config.default.create_table(:transactions) do
    primary_key :id
    foreign_key :category_id, :categories
    column :amount, Integer, null: false
    column :date, Date, null: false
    column :note, String
  end

  config.relation(:categories) do
    schema(infer: true) do
      attribute :id, ROM::SQL::Types::String.meta(primary_key: true)
      associations do
        has_many :transactions
      end
    end
  end

  config.relation(:tags) do
    schema(infer: true) do
      associations do
        has_many :transactions
      end
    end
  end

  config.relation(:transactions) do
    schema(infer: true) do
      associations do
        belongs_to :category, as: :category_id
        has_many :tags
      end
    end
  end
end

cat_repo = Database::CategoryRepo.new(rom)
puts cat_repo.inspect
cat_repo.create(
  id: 'this_is_the_id',
  name: 'Bills'
)
puts cat_repo.name
# cat_repo.delete('this_is_the_id')
# puts cat_repo.name
