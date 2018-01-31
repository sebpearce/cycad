ROM::SQL.migration do
  change do
    create_table :transactions do
      primary_key :id
      foreign_key :category_id, :categories, null: false
      column :amount, Integer, null: false
      column :date, Date, null: false
      column :note, String
      column :tags, String
    end
  end
end
