require 'rails_helper'

RSpec.describe Person, type: :model do
  context "constants" do
    it { expect(Person.person_types).to eq({"customer"=>0, "supplier"=>1, "employee"=>2}) }
  end

  context "associations" do
    it { should belong_to :account }
  end

  context "validations" do
    it { should validate_presence_of :first_name }
    it { should validate_presence_of :last_name }
    it { should validate_presence_of :phone }
  end

  context "instance methods" do
    let(:person) { build(:person, first_name: "John", last_name: "Smith") }
    it "returns full name" do
      expect(person.full_name).to eq "John Smith"
    end
  end

  context "scopes" do
    let(:john) { create(:customer) }
    let(:mark) { create(:customer) }
    let(:ryan) { create(:supplier) }
    let(:bran) { create(:supplier) }
    let(:lore) { create(:employee) }
    let(:bane) { create(:employee) }

    describe "customers" do
      it "returns person_type equals to customer" do
        expect(Person.customers).to eq([john, mark])
      end
    end

    describe "suppliers" do
      it "returns person_type equals to supplier" do
        expect(Person.suppliers).to eq([ryan, bran])
      end
    end

    describe "employees" do
      it "returns person_type equals to employee" do
        expect(Person.employees).to eq([lore, bane])
      end
    end
  end
end
