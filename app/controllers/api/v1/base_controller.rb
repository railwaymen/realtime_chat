require 'api_responder'

module Api
  module V1
    class BaseController < ApplicationController
      self.responder = ApiResponder
      respond_to :json
      skip_before_action :verify_authenticity_token
    end
  end
end
