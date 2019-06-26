# frozen_string_literal: true

class RoomsUser < ApplicationRecord
  belongs_to :room
  belongs_to :user
end
