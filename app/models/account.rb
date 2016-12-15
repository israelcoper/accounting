class Account < ActiveRecord::Base
  has_many :users, dependent: :destroy
  has_many :persons, dependent: :destroy
  validates :name, presence: true

  def customers
    persons.customers
  end

  def suppliers
    persons.suppliers
  end

  def employees
    persons.employees
  end
end
