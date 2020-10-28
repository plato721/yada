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
      end

      private

      def user_params
        params.require(:user).permit(:token, :email)
      end
    end
  end
end
