# frozen_string_literal: true

require 'active_support/concern'

module OwnerConcern
  extend ActiveSupport::Concern

  included do
    belongs_to :user

    def owner?(user)
      user_id == user.id
    end
  end
end
