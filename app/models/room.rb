# frozen_string_literal: true

class Room < ApplicationRecord
  self.inheritance_column = nil

  include Discard::Model

  belongs_to :user
  has_many :messages, class_name: 'RoomMessage', dependent: :destroy
  has_many :rooms_users, dependent: :destroy
  has_many :users, through: :rooms_users, dependent: :destroy

  enum type: { open: 'open', closed: 'closed', direct: 'direct' }

  # Validations
  validates :name, :type, presence: true
  validates :name, uniqueness: true
  validate :validate_name_format

  def channel_name
    [RoomChannel.channel_name, to_gid_param].join(':')
  end

  def direct_room_name_for_user(user)
    other_user_names = users.pluck(:username) - [user.username]
    other_user_names.sort.join(', ')
  end

  def serialized
    Api::V1::RoomSerializer.render_as_hash(self)
  end

  private

  def validate_name_format
    return if direct?

    errors.add(:name, :illegal_characters) unless name =~ /\A([a-zA-Z0-9]|\s)*\z/
  end
end
