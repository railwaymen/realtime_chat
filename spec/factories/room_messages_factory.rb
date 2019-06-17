# frozen_string_literal: true

FactoryBot.define do
  factory :room_message do
    body    { Faker::Lorem.sentence(3, true, 4) }

    room
    user
  end
end