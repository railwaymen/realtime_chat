class Room < ApplicationRecord
  belongs_to :user
  has_many :messages, class_name: 'RoomMessage', dependent: :destroy
end
