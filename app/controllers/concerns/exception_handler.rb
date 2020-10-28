# frozen_string_literal: true

module ExceptionHandler
  extend ActiveSupport::Concern

  included do
    rescue_from ActionController::UnpermittedParameters do |e|
      json_response({ message: e.message }, :bad_request)
    end

    rescue_from ActionController::ParameterMissing do |e|
      json_response({ message: e.message }, :bad_request)
    end

    rescue_from ActiveRecord::RecordNotFound do |e|
      json_response({ message: e.message }, :not_found)
    end
  end
end
