# frozen_string_literal: true

class AttachmentPolicy < ApplicationPolicy
  def destroy?
    record.user_id == user.id
  end
end
