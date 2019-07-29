# frozen_string_literal: true

class RoomMessagePolicy < ApplicationPolicy
  class Scope
    attr_reader :user, :scope

    def initialize(user, scope)
      @user  = user
      @scope = scope
    end

    def resolve
      allowed_rooms_ids = user.rooms_users.pluck(:room_id)
      scope.where('room_messages.room_id IN (?)', allowed_rooms_ids)
    end
  end

  def create?
    record.room.open? || record.room.rooms_users.where(user_id: user.id).exists?
  end

  def update?
    record.user_id == user.id
  end

  def edit?
    update?
  end

  def destroy?
    update?
  end
end
