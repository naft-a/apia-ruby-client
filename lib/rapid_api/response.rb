# frozen_string_literal: true

module RapidAPI
  class Response

    def initialize(client, request, hash, headers, status)
      @client = client
      @request = request
      @hash = hash
      @headers = headers
      @status = status
    end

    attr_reader :request
    attr_reader :hash
    attr_reader :headers
    attr_reader :status

  end
end
