# frozen_string_literal: true

require 'net/http'
require 'json'
require 'rapid_schema_parser'
require 'rapid_api/request_error'
require 'rapid_api/connection_error'

module RapidAPI
  class Client

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

    def load_schema_from_api
      body = make_request(Net::HTTP::Get, 'schema')
      @schema = RapidSchemaParser::Schema.new(body)
      true
    end

    def make_request(type, path)
      request = type.new("/#{namespace}/#{path}")
      request['Content-Type'] = 'application/json'
      yield request if block_given?
      response = make_request_with_error_handling(request)
      handle_response(response)
    end

    private

    def http
      @http ||= begin
        http = Net::HTTP.new(host, port)
        http.use_ssl = ssl?
        http
      end
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
        return body
      end

      raise RequestError.new(self, status_code, body)
    end

  end
end
