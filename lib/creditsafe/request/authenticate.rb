require_relative './default'

module Creditsafe
  module Request
    class Authenticate < Default

      def initialize(username: nil, password: nil)
        raise ArgumentError, "Username must be provided for authenticate request" if username.nil?
        raise ArgumentError, "Password must be provided for authenticate request" if password.nil?

        @username = username
        @password = password
      end

      def fetch
        response = self.class.post('/authenticate', body: {username: @username, password: @password}.to_json, headers: BASE_HEADERS )
        check_response(response)
        JSON.parse(response.body)['token']
      end

      private
      def check_response(response)
        body = JSON.parse(response.body)
        message_starter = 'Request::Authenticate Response '
        if response.code == 401
          message_starter += 'with code 401 '
          message = body.has_key?('message') ? 'Api said: ' + body['message'] :  "no message"
          raise RequestUnauthorizedError, message_starter + message
        elsif response.code >= 400
          raise RequestError, message_starter + 'was not successful'
        end
        raise RequestError, message_starter + 'has no or empty token' unless body.has_key?('token') && !body['token'].to_s.empty?
      end
    end
  end
end

