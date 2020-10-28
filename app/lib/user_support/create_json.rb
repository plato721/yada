# frozen_string_literal: true

module UserSupport
  class CreateJson
    def initialize(user)
      @user = user
    end

    def as_json(_)
      {
        email: user.email,
        token: user.token
      }
    end

    private

    attr_reader :user
  end
end
