require 'rails_helper'

RSpec.describe Activity, type: :model do
  context "associations" do
    it { should belong_to :account }
    it { should belong_to :user }
    it { should belong_to :negotiation }
  end
end
