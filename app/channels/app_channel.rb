# frozen_string_literal: true

class AppChannel < ApplicationCable::Channel
  def subscribed
    stream_for 'app'
  end
end
