# frozen_string_literal: true

require 'spec_helper'

describe RapidAPI::RequestProxy do
  before do
    @api = RapidAPI::API.new('api.example.com', namespace: 'v1')
    @api.load_schema
    @schema = @api.schema
  end

  context '#request' do
    it 'is a GET request when appropriate' do
      route = @api.schema.api.route_set.routes.find do |r|
        r.request_method == 'GET' && r.path == 'products'
      end
      rp = described_class.new(@api, route)
      expect(rp.request).to be_a RapidAPI::Get
    end

    it 'is a POST request when appropriate' do
      route = @api.schema.api.route_set.routes.find do |r|
        r.request_method == 'POST' && r.path == 'products'
      end
      rp = described_class.new(@api, route)
      expect(rp.request).to be_a RapidAPI::Post
    end

    it 'is a PATCH request when appropriate' do
      route = @api.schema.api.route_set.routes.find do |r|
        r.request_method == 'PATCH' && r.path == 'products/:id'
      end
      rp = described_class.new(@api, route)
      expect(rp.request).to be_a RapidAPI::Patch
    end

    it 'is a PUT request when appropriate' do
      route = @api.schema.api.route_set.routes.find do |r|
        r.request_method == 'PUT' && r.path == 'products/:id'
      end
      rp = described_class.new(@api, route)
      expect(rp.request).to be_a RapidAPI::Put
    end

    it 'is a DELETE request when appropriate' do
      route = @api.schema.api.route_set.routes.find do |r|
        r.request_method == 'DELETE' && r.path == 'products/:id'
      end
      rp = described_class.new(@api, route)
      expect(rp.request).to be_a RapidAPI::Delete
    end
  end

  context '#perform' do
    it 'sends the request to the API' do
      route = @api.schema.api.route_set.routes.find do |r|
        r.request_method == 'GET' && r.path == 'products'
      end

      rp = described_class.new(@api, route)
      expect(rp.perform).to be_a RapidAPI::Response
    end
  end

  context '#arguments' do
    it 'proxies arguments to the underlying request instance' do
      route = @api.schema.api.route_set.routes.find do |r|
        r.request_method == 'GET' && r.path == 'products/:id'
      end
      rp = described_class.new(@api, route)
      rp.arguments[:id] = 'poptart'
      expect(rp.request.arguments[:id]).to eq 'poptart'
    end
  end

  context '#endpoint' do
    it 'returns the endpoint details from the schema' do
      route = @api.schema.api.route_set.routes.find do |r|
        r.request_method == 'GET' && r.path == 'products/:id'
      end
      rp = described_class.new(@api, route)
      expect(rp.endpoint).to be_a RapidSchemaParser::Endpoint
    end
  end

  context '#route' do
    it 'returns the route object from the schema' do
      route = @api.schema.api.route_set.routes.find do |r|
        r.request_method == 'GET' && r.path == 'products/:id'
      end
      rp = described_class.new(@api, route)
      expect(rp.route).to eq route
    end
  end
end
