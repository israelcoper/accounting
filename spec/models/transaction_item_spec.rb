require 'rails_helper'

RSpec.describe TransactionItem, type: :model do
  context "association" do
    it { should belong_to :negotiation }
    it { should belong_to :item }
  end
end
