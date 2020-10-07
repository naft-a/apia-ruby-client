# frozen_string_literal: true

module RapidAPI
  class RequestError < StandardError

    attr_reader :status
    attr_reader :body

    def initialize(client, status, body)
      @client = client
      @status = status
      @body = body
    end

  end
end
