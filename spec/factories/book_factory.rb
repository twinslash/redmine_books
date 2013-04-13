require 'factory_girl'

FactoryGirl.define do
  factory :book do
    status :ebook
    author Faker::Name.name
    title Faker::Lorem.words(4).join(' ')
    description Faker::Lorem.words(10).join(' ')

    factory :free_book do
      status :free
    end
  end
end
