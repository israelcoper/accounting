class Category < ActiveRecord::Base
  belongs_to :account, required: false
  belongs_to :parent, class_name: "Category", required: false
  has_many :subcategories, class_name: "Category", foreign_key: :parent_id
end
