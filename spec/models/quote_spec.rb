require 'rails_helper'

describe Quote do
  it { is_expected.to belong_to(:season) }
  it { is_expected.to belong_to(:character) }
  it { is_expected.to belong_to(:episode) }
  it { is_expected.to validate_presence_of(:body) }
  it { is_expected.to validate_uniqueness_of(:body) }
end
