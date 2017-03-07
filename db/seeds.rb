# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

if Category.count == 0
  puts "Create default categories"
  categories = {
    "Current Asset" => ["Cash & Cash Equivalents", "Accounts Receivable", "Advances to Employees"],
    "Non Current Asset" => ["Building", "Vehicles"],
    "Liability" => ["Current Liability", "Non Current Liability"],
    "Equity" => ["Equity"],
    "Income" => ["Sales"],
    "Cost of Sales" => ["Purchases"],
    "Expenses" => ["Employment expenses", "Food", "Others"]
  }

  categories.each do |category, subcategories|
    c = Category.create(name: category)
    subcategories.each do |subcategory|
      c.subcategories.create(name: subcategory)
    end
  end
  puts "Categories count: #{Category.count}"
end
