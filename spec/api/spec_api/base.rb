require 'spec_api/controllers/products_controller'

module SpecAPI
  class Base < Rapid::API

    name 'Example API'
    description 'This is an example API for the purposes of just '

    routes do
      schema
      get 'products', controller: Controllers::ProductsController, endpoint: :list
    end

  end
end
