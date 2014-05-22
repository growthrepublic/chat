module API
  module V1
    class Base < Grape::API
      include ErrorHandling

      version 'v1', using: :path
      mount API::V1::Conversations

      add_swagger_documentation(
        base_path: "/api",
        api_version: 'v1',
        hide_documentation_path: true)
    end
  end
end