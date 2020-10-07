# Rapid API Client

This is a library to faciliate Ruby applications wishing to talk to generic Rapid APIs.

## Getting started

```ruby
# Create a client instance pointing to the API that you wish to connect to.
# By default, it will assume you wish to use SSL and connect on port 443.
api = RapidAPI::API.new('api.example.com')

# Load in the schema from the API if the API supports this
api.load_schema

# Create a request object for the endpoint that you wish to query. You can
# do this by finding it from the API.
request = api.find_request(:post, 'products')

# Set any arguments that you wish to include with the request
request.arguments[:name] = 'My example product'

# Execute the request and get a response back. If there is an issue,
# an exception will be raised here.
response = request.send
```
