module Api::V1
  class SearchesController < AuthenticatedController

    def create
      searcher = create_searcher
      searcher.search

      if !searcher.errors.present?
        render json: { quotes: searcher.quotes }
      else
        render json: { error: { unknown_parameters: searcher.errors }},
          status: :bad_request
      end

    rescue ActionController::UnpermittedParameters => e
      render json: { error:  { unknown_parameters: e.message } },
               status: :bad_request
    rescue ActionController::ParameterMissing => e
      render json: { error:  { missing_parameter: e.message } },
         status: :bad_request
    end

    private

    def create_searcher
      ::Search::Orchestrator.new(
        search_params: search_params,
        user: @current_user
      )

    end
    def search_params
      params.require(:search).permit(:match_text)
    end
  end
end
