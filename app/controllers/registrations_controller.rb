# frozen_string_literal: true

class RegistrationsController < Devise::RegistrationsController
  layout 'application', only: [:edit]

  private

  def account_update_params
    params.fetch(:user, {}).permit(:avatar)
  end

  def update_resource(resource, params)
    resource.update_without_password(params)
  end
end
