# frozen_string_literal: true

class RoomMessagePolicy < ApplicationPolicy
  def create?
    record.room.public? || record.room.rooms_users.where(user_id: user.id).exists?
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
