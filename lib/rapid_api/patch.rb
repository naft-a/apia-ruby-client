# frozen_string_literal: true

require 'rapid_api/request'

module RapidAPI
  class Patch < Request

    self.method = Net::HTTP::Patch

  end
end
