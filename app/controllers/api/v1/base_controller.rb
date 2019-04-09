require 'api_responder'

module Api
  module V1
    class BaseController < ApplicationController
      self.responder = ApiResponder
      respond_to :json
      protect_from_forgery with: :null_session
    end
  end
end
