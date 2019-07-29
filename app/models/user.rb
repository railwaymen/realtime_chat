# frozen_string_literal: true

require 'jwt_service'

class User < ApplicationRecord
  TOKEN_EXPIRATION_LENGTH = 8.hour
  REFRESH_TOKEN_EXPIRATION_LENGTH = 1.year

  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  mount_uploader :avatar, AvatarUploader

  has_many :rooms
  has_many :rooms_users
  has_many :messages, class_name: 'RoomMessage'
  has_many :attachments

  validates :username, uniqueness: true

  def generate_authentication_token
    self.authentication_token = JwtService.encode(payload: { id: id, exp: TOKEN_EXPIRATION_LENGTH.from_now.to_i })
                                          .as_json
  end

  def generate_refresh_token
    self.refresh_token = JwtService.encode(payload: { id: id, exp: REFRESH_TOKEN_EXPIRATION_LENGTH.from_now.to_i })
                                   .as_json
  end

  def update_room_activity(room)
    rooms_activity[room.id] = Time.current.to_s
    save
  end

  def serialized
    Api::V1::UserSerializer.render_as_hash(self)
  end
end
