require 'rails_helper'

describe Character do
  it_behaves_like "a quote attribute"
  it { is_expected.to validate_presence_of(:name) }
  it { is_expected.to validate_uniqueness_of(:name) }
end
