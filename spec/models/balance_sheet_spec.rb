require 'rails_helper'

RSpec.describe BalanceSheet, type: :model do
  context "associations" do
    it { should belong_to :account }
  end

  context "constants" do
    describe "categories" do
      it { expect(BalanceSheet.categories).to eq({"current_asset"=>0, "non_current_asset"=>1, "liability"=>2, "equity"=>3}) }
    end

    describe "template" do
      it { expect(BalanceSheet::Template).to eq({
                                                0=>["Cash & Cash Equivalents", "Accounts Receivable", "Advances to Employees", "Assets"],
                                                1=>["Building", "Vehicles"],
                                                2=>["Current Liability", "Non Current Liability"],
                                                3=>["Capital", "Withdrawals", "Retained Earnings"]}) }
    end
  end
end
