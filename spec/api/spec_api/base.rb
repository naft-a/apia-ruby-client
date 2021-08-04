# frozen_string_literal: true

require 'spec_api/controllers/products_controller'

module SpecAPI
  class Base < Apia::API

    name 'Example API'
    description 'This is an example API for the purposes of just '

    routes do
      schema
      get 'products', controller: Controllers::ProductsController, endpoint: :list
      get 'products/:id', controller: Controllers::ProductsController, endpoint: :info
      post 'products', controller: Controllers::ProductsController, endpoint: :create
      patch 'products/:id', controller: Controllers::ProductsController, endpoint: :update
      put 'products/:id', controller: Controllers::ProductsController, endpoint: :update
      delete 'products/:id', controller: Controllers::ProductsController, endpoint: :delete
    end

  end
end
