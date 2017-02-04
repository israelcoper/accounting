FactoryGirl.define do
  factory :product do
    association :account

    name { FFaker::Product.product_name }
    description "Some description"
    cost "0.0"
    income "0.0"
    quantity "0"
    purchasing_price "0.0"
    selling_price "0.0"

    factory :invalid_product do
      name nil
    end
  end
end
