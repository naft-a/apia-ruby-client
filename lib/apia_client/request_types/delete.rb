# frozen_string_literal: true

require 'apia_client/request'

module ApiaClient
  class Delete < Request

    self.method = Net::HTTP::Delete

  end
end
