class RoomMessage < ApplicationRecord
  include OwnerConcern

  belongs_to :room

  # Validations
  validates :body, presence: true

  def edited?
    updated_at != created_at
  end
end
