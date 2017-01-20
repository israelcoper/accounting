require 'rails_helper'

RSpec.describe Transaction, type: :model do
  context "constants" do
    it { expect(Transaction::TransactionTypes).to eq(["Invoice", "Payment", "Purchase Order", "Purchase Payment"]) }
    it { expect(Transaction::Status).to eq(%w{ Open Closed Partial Paid }) }
  end

  context "association" do
    it { should belong_to :account }
    it { should belong_to :person }
    it { should belong_to :parent }
    it { should have_many :children }
    it { should have_many :items }
  end

  context "validation" do
    it { validate_numericality_of(:balance).allow_nil }
  end
end
