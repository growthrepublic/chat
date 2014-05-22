module API
  module V1
    module ErrorHandling
      extend ActiveSupport::Concern

      included do
        rescue_from Mongoid::Errors::DocumentNotFound do |e|
          error_response(message: e.message, status: 404)
        end
      end
    end
  end
end