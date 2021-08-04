# frozen_string_literal: true

module ApiaClient
  class RequestError < StandardError

    attr_reader :status
    attr_reader :body

    # rubocop:disable Lint/MissingSuper
    def initialize(client, status, body)
      @client = client
      @status = status
      @body = body

      @error = @body['error']
    end
    # rubocop:enable Lint/MissingSuper

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
      return if @error.nil?

      @error['code']
    end

    def description
      return if @error.nil?

      @error['description']
    end

    def detail
      return if @error.nil?

      @error['detail'] || {}
    end

  end
end
