require 'Date'

@random_transactions = Cycad::Transactions.new(
  (1..10).map do |x|
    rand_amount = rand(50) + 1
    rand_date = Date.new(rand(2) + 2016, rand(12) + 1, rand(27) + 1)
    rand_category = rand(10) + 1
    Cycad::Transaction.new(amount: rand_amount, date: rand_date, category_id: rand_category)
  end
)

transaction_category_names = %w[
  Salary
  Rent
  Petrol
  Stuff
  Things
  Walruses
  Fude
  Gum
  Cats
  Sand
]

@categories = transaction_category_names.map do |name|
  Cycad::Category.new(name: name)
end
