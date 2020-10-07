# frozen_string_literal: true

require_relative './lib/rapid_api/version'

Gem::Specification.new do |s|
  s.name          = 'rapid_api'
  s.description   = 'A client library for talking to any Rapid API.'
  s.summary       = s.description
  s.homepage      = 'https://github.com/krystal/rapid_api_client'
  s.version       = RapidAPI::VERSION
  s.files         = Dir.glob('VERSION') + Dir.glob('{lib}/**/*')
  s.require_paths = ['lib']
  s.authors       = ['Adam Cooke']
  s.email         = ['adam@krystal.uk']
  s.add_runtime_dependency 'json'
  s.add_runtime_dependency 'rapid-schema-parser'
  s.required_ruby_version = '>= 2.5'
end
