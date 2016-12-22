class Product < ActiveRecord::Base

  store_accessor :fields,
    :number_of_sack, :number_of_kilo, :average_kilo_per_sack, :price_per_kilo,
    :price, :quantity
  
  enum product_type: [:rice, :grocery_item]

  belongs_to :account

  validates :product_type, presence: true
  validates :name, presence: true
  validates :number_of_sack, :number_of_kilo, :average_kilo_per_sack, :price_per_kilo, numericality: true, if: Proc.new {|p| p.rice? }
  validates :price, :quantity, numericality: true, if: Proc.new {|p| p.grocery_item? }

end
