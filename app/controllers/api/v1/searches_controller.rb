# frozen_string_literal: true

module Api
  module V1
    class SearchesController < AuthenticatedController
      def create
        searcher = create_searcher
        searcher.search

        if searcher.errors.blank?
          json_response({ quotes: searcher.quotes })
        else
          json_response({ message: searcher.errors }, :bad_request)
        end
      end

      private

      def create_searcher
        ::SearchSupport::Orchestrator.new(
          search_params: search_params,
          user: @current_user
        )
      end

      def search_params
        params.require(:search).permit([
                                         :match_text,
                                         { filters: [
                                           only: {
                                             characters: []
                                           },
                                           not: {
                                             characters: []
                                           }
                                         ],
                                           sort: [
                                             :body
                                           ] }
                                       ])
      end
    end
  end
end
