require 'rails_helper'

RSpec.describe BalanceSheet, type: :model do
  context "associations" do
    it { should belong_to :account }
  end

  context "constants" do
  end
end
