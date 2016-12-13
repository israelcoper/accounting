class Account < ActiveRecord::Base
  has_many :users, dependent: :destroy
  has_many :persons, dependent: :destroy
  validates :name, presence: true
end
