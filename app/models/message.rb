require "mongoid_embed_finder/runner"

class Message
  include Mongoid::Document
  include Mongoid::Timestamps

  field :user_id, type: Integer
  field :type,    type: String
  field :body,    type: String

  embedded_in :conversation

  def self.from_attributes_by_id(id, conversation_id: nil)
    parent = { include_fields: [:subscribers] }
    parent.merge!(id: conversation_id) if conversation_id

    finder = MongoidEmbedFinder::Runner.new(self, :conversation)
    message = finder.first(id: id, parent: parent)
  end
end