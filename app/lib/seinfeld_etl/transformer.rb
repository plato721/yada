module SeinfeldEtl
  class Transformer
    def objects_transformers
      @objects_transformers ||= begin
        [
          ["author", AuthorTransformer.new],
          ["episode", EpisodeTransformer.new],
          ["season", SeasonTransformer.new],
          ["quote", QuoteTransformer.new]
        ]
      end
    end

    def transform(row)
      objects_transformers.map do |raw_attribute_key, transformer|
        transformer.transform(row[raw_attribute_key])
      end.to_h
    end
  end

  class AuthorTransformer
    def transform(value)
      [ :character_id, Character.find_or_create_by(name: value).id ]
    end
  end

  class EpisodeTransformer
    def transform(value)
      [ :episode_id, Episode.find_or_create_by(number: value.to_i).id ]
    end
  end

  class SeasonTransformer
    def transform(value)
      [ :season_id, Season.find_or_create_by(number: value.to_i).id ]
    end
  end

  class QuoteTransformer
    def transform(value)
      [ :body, value ]
    end
  end
end
