require 'rails_helper'

RSpec.describe Item, type: :model do

  context "constants" do
    it { expect(Item::Units).to eq %w{ none hour kilo liter pack piece unit } }
  end

  context "associations" do
    it { should belong_to :account }
  end

  context "validations" do
    it { should validate_presence_of :item_number }
    it { should validate_presence_of :name }
    it { should validate_presence_of :unit }

    it { should validate_uniqueness_of :name }

    it { should validate_numericality_of :purchase_price }
    it { should validate_numericality_of :selling_price }
  end

=begin
  context "scope" do
    let(:yr) { Date.today.strftime("%Y").to_i }
    let(:fr) { Date.new(year) }
    let(:to) { Date.new(year, 12, 31) }
  end
=end

end
