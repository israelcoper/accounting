FactoryGirl.define do
  factory :product do
    association :account

    name { FFaker::Product.product_name }
    fields { Hash.new }

    factory :rice do
      product_type 0
    end

    factory :invalid_product do
      name nil
    end
  end
end
