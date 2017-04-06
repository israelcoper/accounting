class Activity < ActiveRecord::Base
  belongs_to :user
  belongs_to :negotiation, class_name: "Transaction", foreign_key: :transaction_id

  default_scope { order(created_at: "DESC") }
end
