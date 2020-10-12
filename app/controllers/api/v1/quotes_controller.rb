module Api::V1
  class QuotesController < ApplicationController
    def index
      @quotes = Quote.all
      render json: { quotes: @quotes }
    end
  end
end
