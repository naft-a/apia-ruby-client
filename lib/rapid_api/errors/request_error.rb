# frozen_string_literal: true

module RapidAPI
  class RequestError < StandardError

    attr_reader :status
    attr_reader :body

    def initialize(client, status, body)
      @client = client
      @status = status
      @body = body

      @error = @body['error']
    end

    def to_s
      string = ["[#{@status}]"]
      if code && description
        string << "#{code}: #{description}"
      elsif code
        string << code
      else
        string << @body
      end
      string.join(' ')
    end

    def code
      @error['code']
    end

    def description
      @error['description']
    end

    def detail
      @error['detail'] || {}
    end

  end
end
