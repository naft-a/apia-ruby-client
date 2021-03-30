# frozen_string_literal: true

require 'rapid_api/errors/connection_error'

module RapidAPI
  class TimeoutError < ConnectionError
  end
end
