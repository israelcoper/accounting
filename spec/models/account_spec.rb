require 'rails_helper'

RSpec.describe Account, type: :model do
  context "associations" do
    it { should have_many :users }
  end

  context "validations" do
    it { should validate_presence_of :name }
  end
end
