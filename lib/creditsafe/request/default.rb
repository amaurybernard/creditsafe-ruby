require 'httparty'

require_relative '../authentication_token'
require_relative '../errors'

module Creditsafe
  module Request
    class Default
      include HTTParty
      base_uri 'https://connect.creditsafe.com/v1/'
      BASE_HEADERS = {'Content-Type' => 'application/json' }
      @@authentication_token = nil

      def self.authentication_token=(authentication_token)
        @@authentication_token= authentication_token
      end

      protected
      def self.authentication_token
        @@authentication_token
      end

      def check_token_initialized
        raise RequestError, "Request::Default token haven't been initialize" if @@authentication_token.nil?
      end

      def check_response(response)
        body = JSON.parse(response.body)
        message_starter = self.class.to_s + ' Response '

        if response.code >= 400
          STDERR.puts message_starter + 'contain message:'
          STDERR.puts body['message'] if body.has_key?('message')
          raise RequestError, message_starter + 'was not successful'
        end
      end

    end
  end
end