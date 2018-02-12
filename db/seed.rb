require 'Date'
require 'cycad'

transaction_category_names = %w[
  Salary
  Rent
  Petrol
  Stuff
  Clothes
  Things
  Walruses
  Fude
  Gum
  Cats
  Sand
]

@categories = transaction_category_names.map do |name|
  Cycad.create_category(name).value
end

@random_transactions = (1..10).map do |x|
  rand_amount = rand(1000) - 500
  rand_date = Date.new(rand(2) + 2016, rand(12) + 1, rand(27) + 1)
  Cycad.create_transaction(amount: rand_amount, date: rand_date, category_id: @categories.sample.id)
end

