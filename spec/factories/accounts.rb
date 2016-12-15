FactoryGirl.define do
  factory :account do
    name  { FFaker::Company.name }
    address { Hash.new }

    # after(:build) do |account|
    #   Person.person_types.keys.cycle(2).each do |person|
    #     account.persons << build(:person, person_type: person, account: account)
    #   end
    # end

    factory :invalid_account do
      name nil
    end
  end
end
