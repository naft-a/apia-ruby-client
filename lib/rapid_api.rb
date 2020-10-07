# frozen_string_literal: true

require 'rapid_api/delete'
require 'rapid_api/get'
require 'rapid_api/patch'
require 'rapid_api/post'
require 'rapid_api/put'

require 'rapid_api/api'

module RapidAPI

  class << self

    def load(*args)
      API.load(*args)
    end

  end

end
