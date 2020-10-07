# frozen_string_literal: true

require 'rapid_api/request'

module RapidAPI
  class Delete < Request

    self.method = Net::HTTP::Delete

  end
end
