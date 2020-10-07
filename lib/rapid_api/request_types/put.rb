# frozen_string_literal: true

require 'rapid_api/request'

module RapidAPI
  class Put < Request

    self.method = Net::HTTP::Put

  end
end
