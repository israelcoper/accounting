class Activity < ActiveRecord::Base
  belongs_to :account
  belongs_to :user
  belongs_to :negotiation, class_name: "Transaction", foreign_key: :transaction_id

  default_scope { order(created_at: "DESC") }
  scope :recent, -> { where("created_at >= ?", Time.zone.now.beginning_of_day).limit(25) }
end
