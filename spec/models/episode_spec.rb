require 'rails_helper'

describe Episode do
  it_behaves_like "a quote attribute"
  it { is_expected.to validate_presence_of(:number) }
  it { is_expected.to validate_uniqueness_of(:number) }
end
