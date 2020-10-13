module Api::V1
  class AuthenticatedController < ::ApplicationController
    before_action :set_user

    private

      def set_user
        return if @user = find_user

        error_message = "Get a token by posting email to /api/v1/users/create"
        render json: { error: error_message }, status: :unauthorized
      end

      def find_user
        User.find_by(token: request.headers["token"])
      end
  end
end
