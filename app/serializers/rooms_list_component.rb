# frozen_string_literal: true

class RoomsListComponent < Blueprinter::Base
  association :current_user, blueprint: Api::V1::CurrentUserSerializer do |user, _options|
    user
  end

  association :rooms, blueprint: Api::V1::RoomSerializer do |_user, options|
    options[:rooms]
  end
end
