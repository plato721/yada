# frozen_string_literal: true

module UserSupport
  class CreateJson
    attr_reader :user

    def initialize(user)
      @user = user
    end

    def as_json(_)
      {
        email: user.email,
        token: user.token
      }
    end
  end
end
