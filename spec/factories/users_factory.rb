# frozen_string_literal: true

FactoryBot.define do
  factory :user do
    sequence(:email)        { |n| "user#{n}@example.com" }
    password                { 'password' }
    username                { [Faker::Name.first_name, Faker::Name.last_name].join('_').downcase }

    factory :user_with_rooms do
      after(:create) do |user|
        5.times { create(:room, user: user) }
      end
    end
  end
end
