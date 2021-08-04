# frozen_string_literal: true

require 'apia_client/request'

module ApiaClient
  class Post < Request

    self.method = Net::HTTP::Post

  end
end
