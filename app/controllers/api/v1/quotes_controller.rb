module Api::V1
  class QuotesController < AuthenticatedController
    def index
      @quotes = Quote.all
      render json: { quotes: @quotes }
    end

    def show
      @quote = Quote.find_by(id: params[:id])

      if @quote
        render json: { quote: @quote }
      else
        render json: { error: "Quote not found" }, status: 404
      end
    end
  end
end
