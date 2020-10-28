# frozen_string_literal: true

module Api
  module V1
    class QuotesController < AuthenticatedController
      def index
        quotes = Quote.includes(:season, :character, :episode)
        json_response({quotes: quotes})
      end

      def show
        quote = Quote.includes(:season, :character, :episode)
                     .find(params[:id])
        json_response(quote: quote)
      end
    end
  end
end
