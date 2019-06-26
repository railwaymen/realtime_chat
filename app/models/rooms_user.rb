# frozen_string_literal: true

class RoomsUser < ApplicationRecord
  belongs_to :room
  belongs_to :user

  def serialized
    Api::V1::RoomUserSerializer.render_as_hash(self)
  end
end
