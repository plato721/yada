# frozen_string_literal: true

RSpec.shared_examples 'a quote attribute' do
  it { is_expected.to have_many(:quotes) }

  it "has a factory that won't violate uniqueness constraints" do
    expect  do
      create_list(infer_factory_name, 2)
    end.to change { described_class.count }.by(2)
  end
end
