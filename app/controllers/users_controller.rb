class UsersController < ApplicationController
  before_action :authenticate_user!
  layout 'signed'

  def index
    @users = User.all
  end
end
