class Product < ActiveRecord::Base

  store_accessor :fields,
    :number_of_sack, :number_of_kilo, :average_kilo_per_sack,
    :quantity,
    :purchasing_price, :selling_price
  
  enum product_type: [:rice, :grocery_item]

  default_scope { order(name: "ASC") }

  scope :rice, -> { where(product_type: 0) }
  scope :groceries, -> { where(product_type: 1) }

  belongs_to :account

  validates :product_type, presence: true
  validates :name, presence: true
  validates :cost, numericality: true
  validates :purchasing_price, :selling_price, numericality: true
  validates :number_of_sack, :number_of_kilo, :average_kilo_per_sack, numericality: true, if: Proc.new {|p| p.rice? }
  validates :quantity, numericality: true, if: Proc.new {|p| p.grocery_item? }

end
