# frozen_string_literal: true

module Api
  module V1
    class AuthenticatedController < ::ApplicationController
      before_action :set_user

      private

      def set_user
        return if @current_user = find_user

        error_message = 'Get a token by posting email to /api/v1/users/create'
        json_response({ message: error_message },:unauthorized)
      end

      def find_user
        User.find_by(token: request.headers['token'])
      end
    end
  end
end
