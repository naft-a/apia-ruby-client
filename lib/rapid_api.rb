# frozen_string_literal: true

require 'rapid_api/request_types/delete'
require 'rapid_api/request_types/get'
require 'rapid_api/request_types/patch'
require 'rapid_api/request_types/post'
require 'rapid_api/request_types/put'

require 'rapid_api/api'

module RapidAPI

  class << self

    def load(*args, **options)
      API.load(*args, **options)
    end

  end

end
