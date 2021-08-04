# frozen_string_literal: true

require 'apia_client/request'

module ApiaClient
  class Patch < Request

    self.method = Net::HTTP::Patch

  end
end
