# frozen_string_literal: true

class RoomPolicy < ApplicationPolicy
  class Scope
    attr_reader :user, :scope

    def initialize(user, scope)
      @user  = user
      @scope = scope
    end

    def resolve
      allowed_rooms_ids = user.rooms_users.pluck(:room_id)
      scope.where("rooms.id IN (?)", allowed_rooms_ids)
    end
  end

  def show?
    record.open? || record.rooms_users.where(user_id: user.id).exists?
  end

  def update?
    !record.direct? && record.user_id == user.id
  end

  def edit?
    update?
  end

  def destroy?
    update?
  end

  def update_activity?
    show?
  end
end
