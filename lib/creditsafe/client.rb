# frozen_string_literal: true

require 'creditsafe/errors'

require 'creditsafe/authentication_token'
require 'creditsafe/request/default'
require 'creditsafe/request/authenticate'
require 'creditsafe/request/companies'
require 'creditsafe/request/company'

require "active_support/notifications"

module Creditsafe
  class Client

    def initialize(username: nil, password: nil, language: 'en')
      raise ArgumentError, "Username must be provided" if username.nil?
      raise ArgumentError, "Password must be provided" if password.nil?
      Request::Default.authentication_token = AuthenticationToken.new(username: username, password: password)

      @params = {
          language: language
      }
      @username = username
      @password = password
    end

    def companies(search_criteria, params: {pageSize: 100})
      search_criteria = params.merge(search_criteria)
      Request::Companies::new(search_criteria).fetch
    end

    def company(creditsafe_id, params: {})
      params = @params.merge(params)
      Request::Company::new(creditsafe_id, params: params).fetch
    end

    def inspect
      "#<#{self.class} @username='#{@username}'>"
    end

    private
    # @return token
    def authenticate
      Request::Authenticate.new(username: @username, password: @password).fetch
    end
  end
end
