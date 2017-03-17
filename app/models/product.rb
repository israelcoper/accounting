class Product < ActiveRecord::Base
  enum category: [:inventory, :non_inventory]

  Units = %w{ none kilo liter pack piece unit }

  default_scope { order(name: "ASC") }

  belongs_to :account

  validates :name, :unit, :product_number, presence: true
  validates :purchase_price, :selling_price, :quantity, numericality: true

end
