# frozen_string_literal: true

FactoryBot.define do
  factory :room do
    sequence(:name) { |n| "Room #{n}" }
    public          { true } # rubocop:disable Layout/EmptyLinesAroundAccessModifier

    user

    factory :room_with_participants do
      public { false } # rubocop:disable Layout/EmptyLinesAroundAccessModifier

      after(:create) do |room|
        3.times { create(:rooms_user, room: room) }
      end
    end
  end
end
