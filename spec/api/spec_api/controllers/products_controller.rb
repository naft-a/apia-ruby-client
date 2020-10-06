# frozen_string_literal: true

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

    end
  end
end
