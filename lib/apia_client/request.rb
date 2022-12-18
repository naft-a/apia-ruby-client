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
      @path = path&.sub(/\A\/*\//, '')
      @arguments = {}
    end

    def path_for_net_http
      path
    end

    def path_for_net_http_with_params
      path = path_with_params
      arguments = @arguments.reject { |arg| path_params.include?(arg.inspect) }

      if arguments.any?
        querystring = URI.encode_www_form(_arguments: arguments.to_json)
        "#{path}?#{querystring}"
      else
        path
      end
    end

    def add_arguments_to_request(request)
      request['Content-Type'] = 'application/json'
      request.body = arguments.to_json
    end

    private

    def path_params
      path.split("/").select { |part| part.start_with?(":") }
    end

    def path_with_params
      new_path = path

      arguments.each do |key, value|
        new_path = path.gsub(key.inspect, value)
      end

      new_path
    end

  end

end
