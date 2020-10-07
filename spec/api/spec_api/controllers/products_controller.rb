# frozen_string_literal: true

require 'securerandom'

module SpecAPI
  module Controllers
    class ProductsController < Rapid::Controller

      name 'Products API'

      endpoint :list do
        name 'List products'
        field :products, [:string]
        action do
          response.add_field :products, %w[gameboy xbox kindle iphone]
        end
      end

      endpoint :info do
        name 'Product info'
        argument :id, :string
        field :product, :string
        action do
          response.add_field :product, request.arguments[:id]
        end
      end

      endpoint :create do
        name 'Create a product'
        argument :name, :string, required: true
        field :id, :string
        field :name, :string
        action do
          id = SecureRandom.uuid
          response.add_field :id, id
          response.add_field :name, request.arguments[:name]
        end
      end

    end
  end
end
