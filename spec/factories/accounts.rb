FactoryGirl.define do
  factory :account do
    name  { FFaker::Company.name }
    address { Hash.new }
  end
end
