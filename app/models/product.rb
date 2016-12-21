class Product < ActiveRecord::Base

  store_accessor :fields,
    :number_of_sack, :number_of_kilo, :average_kilo_per_sack, :price_per_kilo
  
  enum product_type: [:rice]

  belongs_to :account

  validates :product_type, presence: true
  validates :name, presence: true
  validates :number_of_sack, :number_of_kilo, :average_kilo_per_sack, :price_per_kilo, numericality: true

end
