class Product < ActiveRecord::Base
  enum category: [:inventory, :non_inventory]

  Units = %w{ none kilo liter pack piece unit }

  default_scope { order(name: "ASC") }

  scope :inventory, -> { where(category: categories.fetch("inventory")) }
  scope :non_inventory, -> { where(category: categories.fetch("non_inventory")) }
  scope :income_statement, ->(range) { where(created_at: range) }

  belongs_to :account

  validates :name, :unit, :product_number, presence: true
  validates :purchase_price, :selling_price, :quantity, numericality: true
end
