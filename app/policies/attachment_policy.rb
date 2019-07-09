# frozen_string_literal: true

class AttachmentPolicy < ApplicationPolicy
  class Scope
    attr_reader :user, :scope

    def initialize(user, scope)
      @user  = user
      @scope = scope
    end

    def resolve
      scope.where(user_id: @user.id)
    end
  end

  def destroy?
    record.user_id == user.id
  end
end
