RSpec.shared_examples "a quote attribute" do
  it { is_expected.to have_many(:quotes) }

  it "has a factory that won't violate uniqueness constraints" do
    expect{
      create_list(infer_factory_name, 2)
    }.to change{ described_class.count }.by(2)
  end
end
