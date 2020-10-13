module Api::V1
  class SearchesController < AuthenticatedController
    def create
      @quotes = Quote.where('body LIKE ?', search_params[:match_text])
      render json: { quotes: @quotes }
    end

    private
    def search_params
      params.require(:search).permit(:match_text)
    end
  end
end
