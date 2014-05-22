require "mongoid_entity_formatter"

module API
  module V1
    module Entities
      class Message < Grape::Entity
        include MongoidEntityFormatter

        expose :user_id
        expose :type
        expose :body
        expose :created_at
        expose_mongo_id :conversation_id do |message, options|
          message.conversation.id
        end
      end
    end
  end
end