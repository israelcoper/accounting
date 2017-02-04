require 'rails_helper'

RSpec.describe Product, type: :model do

  context "associations" do
    it { should belong_to :account }
  end

  context "validations" do
    it { should validate_presence_of :name }

    it { should validate_numericality_of :income }
    it { should validate_numericality_of :cost }
    it { should validate_numericality_of :purchasing_price }
    it { should validate_numericality_of :selling_price }
    it { should validate_numericality_of :quantity }
  end

end
