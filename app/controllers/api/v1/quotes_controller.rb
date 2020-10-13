module Api::V1
  class QuotesController < AuthenticatedController
    def index
      @quotes = Quote.all
      render json: { quotes: @quotes }
    end

    def show
      @quote = Quote.find_by(id: params[:id])
      render json: { quote: @quote }
    end
  end
end
