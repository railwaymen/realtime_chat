class RoomMessage < ApplicationRecord
  belongs_to :room
  belongs_to :user

  # Validations
  validates :body, presence: true
end
