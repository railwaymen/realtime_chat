# frozen_string_literal: true

class UsersSelectComponent < Blueprinter::Base
  field :value do |user, _options|
    user.id
  end

  field :label do |user, _options|
    user.username
  end
end
