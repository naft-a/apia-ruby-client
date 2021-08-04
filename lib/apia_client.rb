# frozen_string_literal: true

require 'apia_client/request_types/delete'
require 'apia_client/request_types/get'
require 'apia_client/request_types/patch'
require 'apia_client/request_types/post'
require 'apia_client/request_types/put'

require 'apia_client/api'

module ApiaClient

  class << self

    def load(*args, **options)
      API.load(*args, **options)
    end

  end

end
