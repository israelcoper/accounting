require 'rails_helper'

RSpec.describe Item, type: :model do
  context "association" do
    it { should belong_to :negotiation }
    it { should belong_to :product }
  end
end
