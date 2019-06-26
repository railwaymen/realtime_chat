# frozen_string_literal: true

module Api
  module V1
    class ErrorSerializer < Blueprinter::Base
      field :errors do |resource, _options|
        resource.errors.details
      end
    end
  end
end
