require 'rails_helper'

RSpec.describe Product, type: :model do

  context "constants" do
    it { expect(Product.product_types).to eq({"rice"=>0}) }
  end

  context "associations" do
    it { should belong_to :account }
  end

  context "validations" do
    it { should validate_presence_of :product_type }
    it { should validate_presence_of :name }

    it { should validate_numericality_of :number_of_sack }
    it { should validate_numericality_of :number_of_kilos }
    it { should validate_numericality_of :average_kilo_per_sack }
    it { should validate_numericality_of :price_per_kilo }
  end

end
