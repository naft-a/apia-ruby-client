# frozen_string_literal: true

require 'rapid_api/request'

module RapidAPI
  class Post < Request

    self.method = Net::HTTP::Post

  end
end
