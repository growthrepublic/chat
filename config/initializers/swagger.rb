GrapeSwaggerRails.options.url      = '/api/v1/swagger_doc.json'
GrapeSwaggerRails.options.app_name = 'Swagger'
GrapeSwaggerRails.options.app_url  = 'http://localhost:3000'
unless Rails.env.development?
  GrapeSwaggerRails.options.api_key_name = 'token'
  GrapeSwaggerRails.options.api_key_type = 'query'
end