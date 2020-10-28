# frozen_string_literal: true

module Api
  module V1
    class QuotesController < AuthenticatedController
      def index
        @quotes = Quote.includes(:season, :character, :episode)
        render json: { quotes: @quotes }
      end

      def show
        @quote = Quote.includes(:season, :character, :episode)
                      .find_by(id: params[:id])
        if @quote
          render json: { quote: @quote }
        else
          render json: { error: 'Quote not found' }, status: 404
        end
      end
    end
  end
end
