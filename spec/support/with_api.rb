# frozen_string_literal: true

RSpec.shared_context 'with API' do
  require 'rack'
  require 'rapid'
  require 'webmock/rspec'

  $LOAD_PATH.unshift(File.expand_path('../api', __dir__))
  require 'spec_api/base'

  let(:rack_app) do
    Rapid::Rack.new(nil, SpecAPI::Base, 'v1', development: true)
  end

  before do
    stub_request(:any, /api.example.com/).to_rack(rack_app)
  end
end
