class Transaction < ActiveRecord::Base

  Types = ["Invoice", "Payment", "Purchase Order", "Purchase Payment", "Expense"]
  Status = %w{ Open Closed Partial Paid }
  Number = 1000

  enum payment_method: [:cash, :check, :bank_transfer]

  belongs_to :account
  belongs_to :person
  belongs_to :parent, class_name: "Transaction"
  has_many :children, class_name: "Transaction", foreign_key: :parent_id
  has_many :items, dependent: :destroy

  accepts_nested_attributes_for :items, allow_destroy: true, reject_if: proc {|attributes| attributes["amount"].blank? }

  default_scope { order(transaction_number: "ASC") }
  scope :sales, -> { where(transaction_type: Types.values_at(0)) }
  scope :purchases, -> { where(transaction_type: Types.values_at(2)) }
  scope :expenses, -> { where(transaction_type: Types.values_at(4)) }
  scope :invoice, -> { where(transaction_type: Types[0], status: [Status[0], Status[2]]) }
  scope :purchase, -> { where(transaction_type: Types[2], status: [Status[0], Status[2]]) }

  # (Time.now - 30.days)..Time.now or 30.days.ago..Time.now
  scope :overdue, ->(type, due_date) { where(transaction_type: type, due_date: due_date).where.not(balance: 0.0) }

  before_save :set_status, if: proc {|t| t.new_record? }
  before_save :generate_invoice_number, if: proc {|t| t.new_record? && t.transaction_type == Types[0]}
  before_save :generate_purchase_number, if: proc {|t| t.new_record? && t.transaction_type == Types[2]}
  before_save :generate_expense_number, if: proc {|t| t.new_record? && t.transaction_type == Types[4]}

  ## PAYMENT CALLBACKS
  before_save :set_total_of_payment_transaction, if: proc {|t| t.transaction_type == Types[1]}
  before_save :set_total_of_purchase_payment_transaction, if: proc {|t| t.transaction_type == Types[3]}
 
  after_save :deduct_balance_of_parent_invoice, if: proc {|t| t.transaction_type == Types[1]}
  after_save :deduct_balance_of_parent_purchase, if: proc {|t| t.transaction_type == Types[3]}
  after_save :update_status_of_parent_invoice, if: proc {|t| t.transaction_type == Types[1]}
  after_save :update_status_of_parent_purchase, if: proc {|t| t.transaction_type == Types[3]}

  validates :balance, numericality: true, allow_blank: true

  paginates_per 10

  # pg_search_scope :search, against: [:transaction_type, :transaction_number], associated_against: { person: [:first_name, :last_name] }, using: { tsearch: {prefix: true} }

  def add_balance_to_person
    self.person.balance += balance
    self.person.save
  end

  def deduct_balance_of_person
    self.person.balance -= payment
    self.person.save
  end

  def cancel_person_transaction!
    self.person.balance -= balance
    self.person.save
  end

  protected

  def generate_invoice_number
    number = (account.transactions.sales.count > 0) ? (account.transactions.sales.last.transaction_number.match(/\d+/).to_s.to_i + 1) : (Number + 1)
    self.transaction_number = ["INV" , number].join("_")
  end

  def generate_purchase_number
    number = (account.transactions.purchases.count > 0) ? (account.transactions.purchases.last.transaction_number.match(/\d+/).to_s.to_i + 1) : (Number + 1)
    self.transaction_number = ["PO" , number].join("_")
  end

  def generate_expense_number
    number = (account.transactions.expenses.count > 0) ? (account.transactions.expenses.last.transaction_number.match(/\d+/).to_s.to_i + 1) : (Number + 1)
    self.transaction_number = ["EXP" , number].join("_")
  end

  def set_status
    self.status = case transaction_type
                  when Types[0]
                    Status[0]
                  when Types[1]
                    Status[1]
                  when Types[2]
                    Status[0]
                  when Types[3]
                    Status[1]
                  else
                    Status[3]
                  end
  end

  def set_total_of_payment_transaction
    self.total = -payment
  end
  alias_method :set_total_of_purchase_payment_transaction, :set_total_of_payment_transaction

  def deduct_balance_of_parent_invoice
    self.parent.balance -= payment
    self.parent.save
  end
  alias_method :deduct_balance_of_parent_purchase, :deduct_balance_of_parent_invoice

  def update_status_of_parent_invoice
    new_status = (parent.balance == 0.0) ? Status[3] : Status[2]
    self.parent.update(status: new_status)
  end
  alias_method :update_status_of_parent_purchase, :update_status_of_parent_invoice

end
