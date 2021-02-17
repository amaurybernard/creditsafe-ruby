# frozen_string_literal: true
require_relative  './default'

module Creditsafe
  module Request
    class Company < Request::Default

      def initialize(creditsafe_id, params: nil)
        @creditsafe_id = creditsafe_id
        @params = params
        check_token_initialized
      end

      def fetch
        response = self.class.get('/companies/' + @creditsafe_id, query: @params, headers: @@authentication_token.headers(BASE_HEADERS))
        puts response
        check_response(response)
        response
      end

    end
  end
end
