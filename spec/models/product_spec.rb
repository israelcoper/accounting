require 'rails_helper'

RSpec.describe Product, type: :model do

  context "constants" do
    it { expect(Product::Units).to eq %w{ none kilo liter pack piece unit } }
  end

  context "associations" do
    it { should belong_to :account }
  end

  context "validations" do
    it { should validate_presence_of :name }
    it { should validate_presence_of :unit }
    it { should validate_presence_of :product_number }

    it { should validate_numericality_of :purchase_price }
    it { should validate_numericality_of :selling_price }
    it { should validate_numericality_of :quantity }
  end

end
