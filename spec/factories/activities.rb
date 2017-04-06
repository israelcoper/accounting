FactoryGirl.define do
  sequence(:activity_name) {|n| "Activity #{n}"}

  factory :activity do
    association :user
    association :negotiation, factory: :transaction

    name { generate(:activity_name) }
  end
end
