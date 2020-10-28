# frozen_string_literal: true

module SearchSupport
  module ExceptionHandler
    extend ActiveSupport::Concern

    class_methods do
      def record_errors_and_terminate(e, results_builder)
        results_builder.complete!
        results_builder.errors = e.message
      end
    end
  end
end
