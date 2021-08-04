# frozen_string_literal: true

require 'apia_client/errors/connection_error'

module ApiaClient
  class TimeoutError < ConnectionError
  end
end
