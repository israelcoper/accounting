FactoryGirl.define do
  factory :transaction do
    association :account
    association :person

    transaction_number 1001
    transaction_date { DateTime.now }
    due_date { DateTime.now + 5.days }
    notes "MyText"
    status "Open"
    payment 0
    balance 100
    total 100

    factory :invoice do
      transaction_type Transaction::Types[0]
    end

    factory :purchase do
      transaction_type Transaction::Types[2]
    end
  end
end
