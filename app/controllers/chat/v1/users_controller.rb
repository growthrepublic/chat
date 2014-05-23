require 'websocket_messaging/channel'

class Chat::V1::UsersController < ApplicationController
  include Tubesock::Hijack

  def show
    user_id = params[:id]

    messaging = WebsocketMessaging::Channel.new(user_id) do |channel|
      channel.onmessage do |data|
        message = append_message(data.merge(user_id: user_id))
        push_to_subscribers(channel, message)
      end

      channel.before_send do |data|
        present_message(data)
      end
    end

    hijack(&messaging.public_method(:start))
  end

  private

  def present_message(data)
    message = Message.from_attributes_by_id(
      data["message_id"],
      conversation_id: data["conversation_id"])

    return nil unless message
    API::V1::Entities::Message.new(message)
  end

  def append_message(data)
    conversation = Conversation.find(data.delete("conversation_id"))
    message      = Message.new(data)
    conversation.messages << message

    message
  end

  def push_to_subscribers(channel, message)
    conversation = message.conversation
    channel_ids = conversation.subscribers
    channel.notifier.multicast(channel_ids).notify(
      message_id: message.id.to_s,
      conversation_id: conversation.id.to_s)
  end
end