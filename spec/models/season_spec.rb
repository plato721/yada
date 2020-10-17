require 'rails_helper'

describe Season do
  it { is_expected.to have_many(:quotes) }
  it { is_expected.to validate_presence_of(:number) }
  it { is_expected.to validate_uniqueness_of(:number) }
end
