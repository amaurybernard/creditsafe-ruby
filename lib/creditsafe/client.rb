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
    ENVIRONMENTS = %i[live test].freeze

    def initialize(username: nil, password: nil, environment: :live, log_level: :warn)
      raise ArgumentError, "Username must be provided" if username.nil?
      raise ArgumentError, "Password must be provided" if password.nil?
      Request::Default.authentication_token = AuthenticationToken.new(username: username, password: password)

      unless ENVIRONMENTS.include?(environment.to_sym)
        raise ArgumentError, "Environment needs to be one of #{ENVIRONMENTS.join('/')}"
      end

      @environment = environment.to_s
      @log_level = log_level
      @username = username
      @password = password
    end

    # @return token
    # For tests
    def authenticate
      Request::Authenticate.new(username: @username, password: @password).fetch
    end

    def companies(search_criteria)
      Request::Companies::new(search_criteria).fetch
    end

    def company(creditsafe_id, params: nil)
      Request::Company::new(creditsafe_id, params: params).fetch
    end

    def inspect
      "#<#{self.class} @username='#{@username}'>"
    end

    private

    def handle_message_for_response(response)
      [
        *response.xpath("//q1:Message"),
        *response.xpath("//xmlns:Message"),
      ].each do |message|
        api_message = Creditsafe::Messages.for_code(message.attributes["Code"].value)

        api_error_message = api_message.message
        api_error_message += " (#{message.text})" unless message.text.blank?

        raise api_message.error_class, api_error_message if api_message.error?
      end
    end

    # rubocop:disable Style/RescueStandardError
    # rubocop:disable Metrics/MethodLength
    # rubocop:disable Metrics/AbcSize
    def invoke_soap(message_type, message)
      started = Time.now
      notification_payload = { request: message }

      response = client.call(message_type, message: message)
      handle_message_for_response(response)
      notification_payload[:response] = response.body
    rescue Excon::Errors::Timeout => raw_error
      notification_payload[:error] = handle_error(raw_error)
      raise TimeoutError
    rescue Excon::Errors::BadGateway => raw_error
      notification_payload[:error] = handle_error(raw_error)
      raise BadGatewayError
    rescue => raw_error
      processed_error = handle_error(raw_error)
      notification_payload[:error] = processed_error
      raise processed_error
    ensure
      publish("creditsafe.#{message_type}", started, Time.now,
              SecureRandom.hex(10), notification_payload)
    end
    # rubocop:enable Metrics/AbcSize
    # rubocop:enable Metrics/MethodLength
    # rubocop:enable Style/RescueStandardError

    def publish(*args)
      ActiveSupport::Notifications.publish(*args)
    end

    # There's a potential bug in the creditsafe API where they actually return
    # an HTTP 401 if you're unauthorized, hence the sad special case below
    #
    # rubocop:disable Metrics/MethodLength
    def handle_error(error)
      case error
      when Savon::SOAPFault
        return UnknownApiError.new(error.message)
      when Savon::HTTPError
        if error.to_hash[:code] == 401
          return AccountError.new("Unauthorized: invalid credentials")
        end

        return UnknownApiError.new(error.message)
      when Excon::Errors::Error
        return HttpError.new("Error making HTTP request: #{error.message}")
      end
      error
    end
    # rubocop:enable Metrics/MethodLength
  end
end
