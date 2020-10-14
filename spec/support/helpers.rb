module Helpers
  def infer_factory_name
    described_class.to_s.downcase.to_sym
  end

  def json_body
    JSON.parse(response.body)
  end

  def dummy_user
    @dummy_user ||= create(:user)
  end

  def sign_in(user)
    request.headers["token"] = user.token
  end
end
