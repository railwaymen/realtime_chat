# frozen_string_literal: true

class RoomsListComponent < Blueprinter::Base
  field :current_user_id do |user, _options|
    user.id
  end

  association :rooms, blueprint: Api::V1::RoomSerializer do |_user, options|
    options[:rooms]
  end
end
