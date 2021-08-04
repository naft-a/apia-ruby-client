# frozen_string_literal: true

require 'apia_client/request'

module ApiaClient
  class Put < Request

    self.method = Net::HTTP::Put

  end
end
