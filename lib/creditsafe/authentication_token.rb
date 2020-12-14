require 'time'

module Creditsafe
  class AuthenticationToken
    VALIDITY_DURATION = 50 * 60 #in seconds => 50 minutes
    @token = nil
    @expire_at = nil
    @authenticate = nil

    def fetch_new_token
      @expire_at = Time.new + VALIDITY_DURATION
      @token = @authenticate.fetch
    end

    def initialize(username:, password:)
      @authenticate = Request::Authenticate.new(username: username, password: password)
      fetch_new_token
    end

    def headers(previous_header)
      if !@token && @expire_at < Time.now
        fetch_new_token
      end
      { :Authorization => "Bearer #{@token}" }.merge(previous_header)
    end
  end
end