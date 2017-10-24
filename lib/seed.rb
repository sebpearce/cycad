require 'Date'

transactions = (1..10).map do |x|
  rand_id = x
  rand_amt = rand(50) + 1
  rand_date = Date.new(rand(2) + 2016, rand(12) + 1, rand(27) + 1)
  puts "Creating Transaction(id: #{rand_id}, amt: #{rand_amt}, date: #{rand_date})"
  Transaction.new(id: rand_id, amt: rand_amt, date: rand_date)
end

transaction_category_names = %w[
  Salary
  Rent
  Petrol
]

transaction_categories = transaction_category_names.map.with_index do |name, index|
  TransactionCategory.new(id: index, name: name)
end

puts transaction_categories.to_s
