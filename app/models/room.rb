class Room < ApplicationRecord
  include Discard::Model
  include OwnerConcern

  has_many :messages, class_name: 'RoomMessage', dependent: :destroy

  after_discard do
    messages.discard_all
  end

  # Validations
  validates :name, presence: true

  def channel_name
    [RoomChannel.channel_name, self.to_gid_param].join(':')
  end
end
