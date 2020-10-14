module Api::V1
  class SearchesController < AuthenticatedController
    def create
      @quotes = Quote.where('body LIKE ?', search_params[:match_text])
      render json: { quotes: @quotes }

    rescue ActionController::UnpermittedParameters => e
      render json: { error:  { unknown_parameters: e.message } },
               status: :bad_request
    rescue ActionController::ParameterMissing => e
      render json: { error:  { missing_parameter: e.message } },
         status: :bad_request
    end

    private
    def search_params
      params.require(:search).permit(:match_text)
    end
  end
end
