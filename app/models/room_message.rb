class RoomMessage < ApplicationRecord
  include OwnerConcern

  belongs_to :room

  # Validations
  validates :body, presence: true
end
