# frozen_string_literal: true

module RapidAPI
  class RequestProxy

    METHOD_MAP = {
      get: RapidAPI::Get,
      post: RapidAPI::Post,
      patch: RapidAPI::Patch,
      put: RapidAPI::Put,
      delete: RapidAPI::Delete
    }.freeze

    attr_reader :route
    attr_reader :request

    def initialize(client, route)
      @client = client
      @route = route

      request_class = METHOD_MAP[@route.request_method.downcase.to_sym]
      @request = request_class.new(@route.path)
    end

    def send
      @client.request(@request)
    end

    def arguments
      @request.arguments
    end

    def endpoint
      @route.endpoint
    end

  end
end
