# frozen_string_literal: true

module Api
  module V1
    class UsersController < ApplicationController

      # POST /api/v1/users
      def create
        user = User.new(user_params)

        if user.save
          user = ::UserSupport::CreateJson.new(user)
          render json: user, status: :created
        else
          render json: user.errors, status: :unprocessable_entity
        end
      rescue ActionController::UnpermittedParameters => e
        render json: { error:  { unknown_parameters: e.message } },
               status: :bad_request
      rescue ActionController::ParameterMissing => e
        render json: { error:  { missing_parameter: e.message } },
               status: :bad_request
      end

      private

      def user_params
        params.require(:user).permit(:token, :email)
      end
    end
  end
end
