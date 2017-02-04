class Product < ActiveRecord::Base

  default_scope { order(name: "ASC") }

  belongs_to :account

  validates :name, presence: true
  validates :income, numericality: true, allow_blank: true
  validates :cost, :purchasing_price, :selling_price, :quantity, numericality: true

end
