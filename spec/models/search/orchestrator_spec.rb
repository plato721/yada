require 'rails_helper'

describe Search::Orchestrator do
  before(:all) do
    @user = create(:user)
    @valid_params = ActionController::Parameters
                    .new({match_text: "yada"})
                    .permit(:match_text)
                    .freeze
  end

  it "records the search" do
    recorder = Search::Recorder.new
    allow(recorder).to receive(:record)
    orchestrator = described_class.new(
      user: @user,
      search_params: @valid_params,
      recorder: recorder)

    orchestrator.search

    expect(recorder).to have_received(:record).with(@user, "yada")
  end
end
