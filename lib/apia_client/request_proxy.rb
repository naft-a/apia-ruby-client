# frozen_string_literal: true

module ApiaClient
  class RequestProxy

    METHOD_MAP = {
      get: ApiaClient::Get,
      post: ApiaClient::Post,
      patch: ApiaClient::Patch,
      put: ApiaClient::Put,
      delete: ApiaClient::Delete
    }.freeze

    attr_reader :route
    attr_reader :request

    def initialize(client, route)
      @client = client
      @route = route

      request_class = METHOD_MAP[@route.request_method.downcase.to_sym]
      @request = request_class.new(@route.path)
    end

    def perform
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
