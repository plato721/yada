# frozen_string_literal: true

module SeinfeldEtl
  class Transformer
    def transform(row)
      raw_attributes.map do |raw_attribute_key|
        self.send("map_#{raw_attribute_key}".to_sym, row[raw_attribute_key])
      end.to_h
    end

    private

    def raw_attributes
      %w[author episode season quote]
    end

    def map_author(value)
      [:character_id, Character.find_or_create_by(name: value).id]
    end

    def map_episode(value)
      [:episode_id, Episode.find_or_create_by(number: value.to_i).id]
    end

    def map_season(value)
      [:season_id, Season.find_or_create_by(number: value.to_i).id]
    end

    def map_quote(value)
      [:body, value]
    end
  end
end
