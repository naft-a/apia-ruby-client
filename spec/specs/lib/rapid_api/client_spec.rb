# frozen_string_literal: true

require 'spec_helper'

describe RapidAPI::Client do
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

  context '#make_request' do
    it 'parses JSON from a response' do
      stub_request(:any, /api.example.com/).to_return(
        body: '{"hello":"world"}',
        headers: { 'Content-Type' => 'application/json' }
      )
      response = client.make_request(Net::HTTP::Get, 'example')
      expect(response).to be_a Hash
    end
    it 'returns the raw body if not a JSON response' do
      stub_request(:any, /api.example.com/).to_return(
        body: 'Hello world!'
      )
      response = client.make_request(Net::HTTP::Get, 'example')
      expect(response).to eq 'Hello world!'
    end

    it 'raise a request error is not 2xx' do
      stub_request(:any, /api.example.com/).to_return(
        body: 'Hello world!',
        status: 404
      )
      expect { client.make_request(Net::HTTP::Get, 'example') }.to raise_error RapidAPI::RequestError do |e|
        expect(e.status).to eq 404
        expect(e.body).to eq 'Hello world!'
      end
    end

    it 'raises a connection error if there is a connection error' do
      stub_request(:any, /api.example.com/).to_raise Errno::ECONNREFUSED
      expect { client.make_request(Net::HTTP::Get, 'example') }.to raise_error RapidAPI::ConnectionError
    end

    it 'raises a connection error if there is a timeout' do
      stub_request(:any, /api.example.com/).to_timeout
      expect { client.make_request(Net::HTTP::Get, 'example') }.to raise_error RapidAPI::ConnectionError
    end
  end

  context '#load_schema_from_api' do
    it 'loads the schema' do
      expect(client.load_schema_from_api).to be true
      expect(client.schema).to be_a RapidSchemaParser::Schema
    end

    it 'marks the schema as loaded' do
      expect(client.load_schema_from_api).to be true
      expect(client.schema?).to be true
    end

    it 'raises a connection error if there is a connection error' do
      stub_request(:any, /api.example.com/).to_raise Errno::ECONNREFUSED
      expect { client.load_schema_from_api }.to raise_error RapidAPI::ConnectionError
    end

    it 'raise a connection error if there is a timeout' do
      stub_request(:any, /api.example.com/).to_timeout
      expect { client.load_schema_from_api }.to raise_error RapidAPI::ConnectionError
    end
  end
end
