# frozen_string_literal: true

require 'rails_helper'

describe SearchSupport::Filterer do
  let(:user) { create(:user) }
  let(:characters) do
    [
      create(:character, name: 'George'),
      create(:character, name: 'Paul'),
      create(:character, name: 'Ringo')
    ]
  end
  let(:quotes) do
    [
      create(:quote, character: characters.first),
      create(:quote, character: characters.first),
      create(:quote, character: characters.second),
      create(:quote, character: characters.second),
      create(:quote, body: 'something special 123', character: characters.second)
    ]
  end
  let(:scope) { Quote.includes(:character).where(id: quotes.map(&:id)) }

  context 'character filtering -' do
    it 'filters for only' do
      filters = {
        'only' => {
          'characters' => ['George']
        }
      }
      results_builder = build_results(user, scope, filters: filters)

      results = described_class.execute(results_builder)

      expect(results_builder.errors).to be_blank
      expect(results.distinct.pluck(:name)).to eq(['George'])
    end

    it 'filters for not' do
      filters = {
        'not' => {
          'characters' => ['George']
        }
      }
      results_builder = build_results(user, scope, filters: filters)

      results = described_class.execute(results_builder)

      expect(results_builder.errors).to be_blank
      expect(results.distinct.pluck(:name)).to match_array(['Paul'])
    end
  end
end
