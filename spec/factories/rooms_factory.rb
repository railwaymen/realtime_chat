# frozen_string_literal: true

FactoryBot.define do
  factory :room do
    sequence(:name) { |n| "Room #{n}" }

    user
  end
end
