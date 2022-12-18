# frozen_string_literal: true

require 'apia_client/request'

module ApiaClient
  class Patch < Request

    self.method = Net::HTTP::Patch

    def path_for_net_http
      path_for_net_http_with_params
    end

  end
end
