# frozen_string_literal: true

require 'net/http'

module ApiaClient
  class Request

    class << self

      attr_accessor :method

    end

    attr_reader :path
    attr_reader :arguments
    attr_accessor :http_read_timeout
    attr_accessor :http_open_timeout

    def initialize(path)
      @path = path
      @arguments = {}
    end

    def path_for_net_http
      path
    end

    def add_arguments_to_request(request)
      request['Content-Type'] = 'application/json'
      request.body = arguments.to_json
    end

  end
end
