# frozen_string_literal: true
require_relative  './default'

module Creditsafe
  module Request
    class Companies < Request::Default

      def initialize(search_criteria)
        @search_criteria = search_criteria
        check_token_initialized
        check_search_criteria(search_criteria)
      end

      def fetch
        response = self.class.get('/companies', query: @search_criteria, headers: @@authentication_token.headers(BASE_HEADERS))
        check_response(response)
        response
      end

      private

      # rubocop:disable Metrics/CyclomaticComplexity
      # rubocop:disable Metrics/MethodLength
      # rubocop:disable Metrics/PerceivedComplexity
      # rubocop:disable Metrics/AbcSize
      def check_search_criteria(search_criteria)
        if search_criteria[:countries].nil?
          raise ArgumentError, "countries is a required search criteria"
        end

        unless only_one_required_criteria?(search_criteria)
          raise ArgumentError, "only one of registration_number, company_name or " \
                               "vat number is required search criteria"
        end
      end
      # rubocop:enable Metrics/AbcSize
      # rubocop:enable Metrics/PerceivedComplexity
      # rubocop:enable Metrics/MethodLength
      # rubocop:enable Metrics/CyclomaticComplexity

      def only_one_required_criteria?(search_criteria)
        by_registration_number = !search_criteria[:regNo].nil?
        by_company_name = !search_criteria[:name].nil?
        by_vat_number = !search_criteria[:vatNo].nil?

        (by_registration_number ^ by_company_name ^ by_vat_number) &&
          !(by_registration_number && by_company_name && by_vat_number)
      end
    end
  end
end
