FactoryGirl.define do
  factory :account do
    name  { FFaker::Company.name }
    address { Hash.new }

    factory :invalid_account do
      name nil
    end
  end
end
