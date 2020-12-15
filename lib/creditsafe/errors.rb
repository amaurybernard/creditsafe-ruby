# frozen_string_literal: true

module Creditsafe
  class Error < StandardError; end

  class ApiError < Error; end
  class AccountError < ApiError; end
  class RequestError < ApiError; end
  class ProcessingError < ApiError; end
  class UnknownApiError < ApiError; end

  class RequestUnauthorizedError < RequestError; end

end
