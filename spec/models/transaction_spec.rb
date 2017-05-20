require 'rails_helper'

RSpec.describe Transaction, type: :model do
  context "constants" do
    it { expect(Transaction::Types).to eq(["Invoice", "Payment", "Purchase Order", "Purchase Payment", "Expense"]) }
    it { expect(Transaction::Status).to eq(%w{ Open Closed Partial Paid }) }
    it { expect(Transaction.payment_methods).to eq({"cash"=>0, "check"=>1, "bank_transfer"=>2}) }
  end

  context "association" do
    it { should belong_to :account }
    it { should belong_to :person }
    it { should belong_to :parent }
    it { should have_many :children }
    it { should have_many :transaction_items }
  end

  context "validation" do
    it { validate_numericality_of(:balance).allow_nil }
  end
end
