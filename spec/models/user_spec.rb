require 'rails_helper'

RSpec.describe User, type: :model do
  context "constants" do
    it { expect(User.roles).to eq({"normal"=>0, "accountant"=>1, "admin"=>2}) }
  end

  context "associations" do
    it { should belong_to :account }
  end

  context "validations" do
    it { should validate_presence_of :username }
    it { should validate_presence_of :first_name }
    it { should validate_presence_of :last_name }
    it { should validate_presence_of :role }
    it { should validate_uniqueness_of :username }

    describe "password" do
      let(:user) { build(:user, password: nil, password_confirmation: nil) }

      it "needs a password and password confirmation to save" do
        expect(user).to_not be_valid

        user.password = "password"
        user.password_confirmation = ""
        expect(user).to_not be_valid

        user.password_confirmation = "password"
        expect(user).to be_valid
      end


      it "needs a password and password confirmation to match" do
        user.update_attributes(password: "secret", password_confirmation: "scrt")
        expect(user).to_not be_valid
      end
    end
  end

  context "class methods" do
    describe "non_admin" do
      let(:admin) { create(:admin) }
      let(:accountant) { create(:accountant) }
      let(:normal) { create(:normal) }

      it "returns not admin users" do
        expect(User.non_admin).to eq([accountant, normal])
      end
    end
  end

  context "instance methods" do
    let(:user) { build(:user, first_name: "John", last_name: "Smith") }
    it "returns full name" do
      expect(user.full_name).to eql "John Smith"
    end
  end
end
