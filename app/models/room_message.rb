# frozen_string_literal: true

class RoomMessage < ApplicationRecord
  include Discard::Model
  include OwnerConcern

  belongs_to :room

  # Validations
  validates :body, presence: true

  def edited?
    updated_at != created_at
  end

  def serialized
    Api::V1::MessageSerializer.render_as_hash(self)
  end
end
