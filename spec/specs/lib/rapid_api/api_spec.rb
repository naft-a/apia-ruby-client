# frozen_string_literal: true

require 'spec_helper'

describe RapidAPI::API do
  subject(:client) { described_class.new('api.example.com', namespace: 'v1') }

  context '#ssl?' do
    it 'is true by default' do
      expect(client.ssl?).to be true
    end

    it 'is true if set as such' do
      client = described_class.new('api.example.com', ssl: true)
      expect(client.ssl?).to be true
    end

    it 'is false if set as such' do
      client = described_class.new('api.example.com', ssl: false)
      expect(client.ssl?).to be false
    end
  end

  context '#port' do
    it 'is 80 if no port is selected and SSL is false' do
      client = described_class.new('api.example.com', ssl: false)
      expect(client.port).to eq 80
    end

    it 'is 443 if no port is selected and SSL is true' do
      client = described_class.new('api.example.com', ssl: true)
      expect(client.port).to eq 443
    end

    it 'is whatever is configured in the options' do
      client = described_class.new('api.example.com', port: 8080)
      expect(client.port).to eq 8080
    end
  end

  context '#namespace' do
    it 'is blank if not specified' do
      client = described_class.new('api.example.com', namespace: nil)
      expect(client.namespace).to eq ''
    end

    it 'is whatever is specified in options' do
      client = described_class.new('api.example.com', namespace: 'core/v1')
      expect(client.namespace).to eq 'core/v1'
    end

    it 'does not contain leading slashes' do
      client = described_class.new('api.example.com', namespace: '/core/v1')
      expect(client.namespace).to eq 'core/v1'
    end

    it 'does not contain trailing slashes' do
      client = described_class.new('api.example.com', namespace: 'core/v1/')
      expect(client.namespace).to eq 'core/v1'
    end
  end

  context '#load_schema' do
    it 'loads the schema' do
      expect(client.load_schema).to be true
      expect(client.schema).to be_a RapidSchemaParser::Schema
    end

    it 'marks the schema as loaded' do
      expect(client.load_schema).to be true
      expect(client.schema?).to be true
    end

    it 'raises a connection error if there is a connection error' do
      stub_request(:any, /api.example.com/).to_raise Errno::ECONNREFUSED
      expect { client.load_schema }.to raise_error RapidAPI::ConnectionError
    end

    it 'raise a connection error if there is a timeout' do
      stub_request(:any, /api.example.com/).to_timeout
      expect { client.load_schema }.to raise_error RapidAPI::ConnectionError
    end
  end

  context '#request' do
    it 'returns a response object' do
      request = RapidAPI::Get.new('products')
      expect(client.request(request)).to be_a RapidAPI::Response
    end

    it 'sends arguments for GET requests' do
      request = RapidAPI::Get.new('products/:id')
      request.arguments[:id] = 'macbook'

      response = client.request(request)
      expect(response).to be_a RapidAPI::Response
      expect(response.hash['product']).to eq 'macbook'
    end

    it 'sends arguments for POST requests' do
      request = RapidAPI::Post.new('products')
      request.arguments[:name] = 'sonos'
      response = client.request(request)
      expect(response).to be_a RapidAPI::Response
      expect(response.hash['name']).to eq 'sonos'
    end

    it 'raises an error if theres an error' do
      request = RapidAPI::Get.new('missing-route')
      expect { client.request(request) }.to raise_error RapidAPI::RequestError do |e|
        expect(e.status).to eq 404
      end
    end

    it 'raises a connection error' do
      request = RapidAPI::Get.new('products')
      stub_request(:any, /api.example.com/).to_raise Errno::ECONNREFUSED
      expect { client.request(request) }.to raise_error RapidAPI::ConnectionError
    end
  end

  context '#create_request' do
    it 'raises an error if the schema has not been loaded' do
      expect { client.create_request(:get, 'products') }.to raise_error RapidAPI::SchemaNotLoadedError
    end

    it 'returns an appropriate request instance' do
      client.load_schema
      request = client.create_request(:get, 'products')
      expect(request).to be_a RapidAPI::RequestProxy
      expect(request.request).to be_a RapidAPI::Get
      expect(request.request.path).to eq 'products'
    end

    it 'returns nil if no request matches anything in the schema' do
      client.load_schema
      expect(client.create_request(:get, 'widgets')).to be_nil
    end
  end
end
