class RoomPolicy < ApplicationPolicy
  class Scope
    attr_reader :user, :scope

    def initialize(user, scope)
      @user  = user
      @scope = scope
    end

    def resolve
      private_rooms_ids = user.rooms_users.pluck(:room_id)
      scope.where('public = true OR id IN (?)', private_rooms_ids)
    end
  end

  def show?
    record.public? || record.rooms_users.where(user_id: user.id).exists?
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
