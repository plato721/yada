module Helpers
  def infer_factory_name
    described_class.to_s.downcase.to_sym
  end

  def json_body
    JSON.parse(response.body)
  end
end
