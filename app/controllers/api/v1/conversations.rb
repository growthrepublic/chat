module API
  module V1
    class Conversations < Grape::API
      include Grape::Kaminari

      resource :conversations do
        params do
          requires :user_id, type: Integer
        end
        get '/' do
          user = User.new(params[:user_id])
          @conversations = Conversation.subscribed_by(user).desc(:updated_at)
          present paginate(@conversations),
            with: API::V1::Entities::Conversation
        end

        params do
          requires :people_ids, type: Array
        end
        post '/' do
          subscribers = User.build_array(params[:people_ids])
          @conversation = Conversation.subscribed_by_all(subscribers).last
          unless @conversation
            @conversation = Conversation.create
            @conversation.add_subscribers(subscribers)
          end
          present @conversation,
            with: API::V1::Entities::Conversation
        end

        params do
          requires :id, type: String
        end
        get ':id/messages' do
          @conversation = Conversation.find(params[:id])
          present paginate(@conversation.messages.desc(:created_at)),
            with: API::V1::Entities::Message
        end

        params do
          requires :id, type: String
          requires :people_ids, type: Array
        end
        post ':id/invite' do
          new_subscribers = User.build_array(params[:people_ids])
          @conversation = Conversation.find(params[:id])
          @conversation.add_subscribers(new_subscribers)
          present @conversation,
            with: API::V1::Entities::Conversation
        end
      end
    end
  end
end