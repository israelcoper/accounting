require 'rails_helper'

RSpec.describe Account, type: :model do
  context "associations" do
    it { should have_many :users }
    it { should have_many :persons }
    it { should have_many :products }
    it { should have_many :transactions }
    it { should have_many :transactions }
    it { should have_many :balance_sheets }
  end

  context "validations" do
    it { should validate_presence_of :name }
    it { should validate_presence_of :industry }
  end

  context "instance methods" do
    let(:account) { create(:account) }

    let(:john) { create(:customer, account: account) }
    let(:mark) { create(:customer, account: account) }
    let(:ryan) { create(:supplier, account: account) }
    let(:bran) { create(:supplier, account: account) }
    let(:lore) { create(:employee, account: account) }
    let(:bane) { create(:employee, account: account) }

    describe "customers" do
      it "returns person_type equals to customer" do
        expect(account.customers).to match_array [john, mark]
      end
    end

    describe "suppliers" do
      it "returns person_type equals to supplier" do
        expect(account.suppliers).to match_array [ryan, bran]
      end
    end

     describe "employees" do
      it "returns person_type equals to employee" do
        expect(account.employees).to match_array [lore, bane]
      end
    end
  end
end
