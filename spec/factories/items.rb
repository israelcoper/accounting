FactoryGirl.define do
  factory :item do
    association :account

    item_number "10000001"
    name { FFaker::Product.product_name }
    description "Some description"
    unit "kilo"
    purchase_price "0.0"
    selling_price "0.0"
    allocated_to_purchase "1001"
    allocated_to_selling "1002"

    factory :invalid_item do
      name nil
    end
  end
end
