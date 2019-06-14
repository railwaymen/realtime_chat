class Room < ApplicationRecord
  belongs_to :user
  has_many :messages, class_name: 'RoomMessage', dependent: :destroy

  validates :name, presence: true
end
