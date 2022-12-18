# frozen_string_literal: true

require 'apia_client/request'
require 'json'
require 'uri'

module ApiaClient
  class Get < Request

    self.method = Net::HTTP::Get

    def path_for_net_http
      path_for_net_http_with_params
    end

    def add_arguments_to_request(request)
      # Don't need to do anything for GET requests...
    end

  end
end
