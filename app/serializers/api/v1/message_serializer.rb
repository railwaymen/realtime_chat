# frozen_string_literal: true

module Api
  module V1
    class MessageSerializer < Blueprinter::Base
      identifier :id

      fields :user_id

      field :created_at, datetime_format: -> (date) { date&.iso8601 }

      field :body do |message, _options|
        message.discarded? ? '[message deleted]' : message.body
      end

      field :edited do |message, _options|
        message.created_at != message.updated_at
      end

      field :deleted do |message, _options|
        message.discarded?
      end

      association :user, blueprint: Api::V1::UserSerializer
    end
  end
end
