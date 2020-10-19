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

  def dummy_search_params
    ActionController::Parameters.new({
      match_text: "yada",
      filters: {
        not: {
          characters: ["Elaine"]
        }
      },
      sort: {
        body: "asc"
      }
    }).permit([:match_text, filters: {}, sort: {} ])
  end

  def build_search_params(match_text: "", filters: {}, sort: {})
    ActionController::Parameters.new({
      match_text: match_text,
      filters: filters,
      sort: sort
    }).permit([:match_text, filters: {}, sort: {} ])
  end

  def sign_in(user)
    request.headers["token"] = user.token
  end
end
