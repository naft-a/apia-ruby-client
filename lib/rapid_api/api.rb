# frozen_string_literal: true

require 'net/http'
require 'json'
require 'rapid_schema_parser'
require 'rapid_api/errors/request_error'
require 'rapid_api/errors/connection_error'
require 'rapid_api/errors/schema_not_loaded_error'
require 'rapid_api/response'
require 'rapid_api/request_proxy'

module RapidAPI
  class API

    attr_reader :host
    attr_reader :headers
    attr_reader :schema

    def initialize(host, **options)
      @host = host
      @headers = options[:headers] || {}
      @options = options
    end

    def ssl?
      @options[:ssl].nil? || @options[:ssl] == true
    end

    def port
      @options[:port] || (ssl? ? 443 : 80)
    end

    def namespace
      (@options[:namespace] || '').sub(/\A\/*/, '').sub(/\/*\z/, '')
    end

    def schema?
      !!@schema
    end

    def load_schema
      response = request(Get.new('schema'))
      @schema = RapidSchemaParser::Schema.new(response.hash)
      true
    end

    def request(request)
      status, headers, body = make_request(request.class.method, request.path_for_net_http) do |req|
        request.add_arguments_to_request(req)
      end
      Response.new(self, request, body, headers, status)
    end

    def perform(*args)
      request = create_request(*args)
      return if request.nil?

      yield request if block_given?
      request.perform
    end

    def create_request(method, path)
      unless schema?
        raise SchemaNotLoadedError, 'No schema has been loaded for this API instance'
      end

      route = schema.api.route_set.routes.find do |r|
        r.request_method == method.to_s.upcase &&
          r.path == path
      end

      return if route.nil?

      RequestProxy.new(self, route)
    end

    private

    def http
      @http ||= begin
        http = Net::HTTP.new(host, port)
        http.use_ssl = ssl?
        http
      end
    end

    def make_request(type, path)
      request = type.new("/#{namespace}/#{path}")
      yield request if block_given?
      response = make_request_with_error_handling(request)
      handle_response(response)
    end

    def make_request_with_error_handling(request)
      http.request(request)
    rescue StandardError => e
      raise ConnectionError, e.message
    end

    def handle_response(response)
      if response['content-type'] =~ /application\/json/
        body = JSON.parse(response.body)
      else
        body = response.body
      end

      status_code = response.code.to_i
      if status_code >= 200 && status_code < 300
        return [status_code, response.to_hash, body]
      end

      raise RequestError.new(self, status_code, body)
    end

    class << self

      def load(*args)
        api = new(*args)
        api.load_schema
        api
      end

    end

  end
end
