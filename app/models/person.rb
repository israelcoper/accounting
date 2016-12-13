class Person < ActiveRecord::Base
  include UserPersonHelper

  self.table_name = "persons"

  enum person_type: [:customer, :supplier, :employee]

  belongs_to :account

  validates :first_name, :last_name, :phone, presence: true
end
