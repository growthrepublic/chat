require "mongoid_entity_formatter"

module API
  module V1
    module Entities
      class Conversation < Grape::Entity
        include MongoidEntityFormatter

        expose :subscribers
        expose_mongo_id :id
      end
    end
  end
end