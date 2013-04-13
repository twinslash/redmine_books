require 'factory_girl'

FactoryGirl.define do
  factory :user do
    firstname Faker::Name.first_name
    lastname Faker::Name.last_name
    login { firstname }
    mail { "#{firstname}.#{lastname}@example.com" }
    password { Faker::Lorem.characters 8 }

    factory :active_user do
      status Principal::STATUS_ACTIVE
    end
  end
end
