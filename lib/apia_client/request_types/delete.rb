# frozen_string_literal: true

require 'apia_client/request'

module ApiaClient
  class Delete < Request

    self.method = Net::HTTP::Delete

    def path_for_net_http
      path_for_net_http_with_params
    end

  end
end
