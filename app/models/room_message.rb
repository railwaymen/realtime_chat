# frozen_string_literal: true

class RoomMessage < ApplicationRecord
  include Discard::Model

  belongs_to :user
  belongs_to :room
  has_many :attachments

  # Validations
  validates :body, presence: true

  def edited?
    updated_at != created_at
  end

  def serialized
    Api::V1::MessageSerializer.render_as_hash(self)
  end
end
