require 'spec_helper'

describe API::V1::Conversations do
  let(:conversation_presenter) { API::V1::Entities::Conversation }
  let(:message_presenter)      { API::V1::Entities::Message }

  describe "GET conversations" do
    context "valid user" do
      let!(:conversation) { create(:conversation, :with_subscribers) }
      let(:user_id)       { conversation.subscribers.sample }

      before(:each) do
        get "/api/v1/conversations", user_id: user_id
      end

      it "contains subscribed conversations" do
        expect(json.first["id"]).to eq conversation.id.to_s
      end

      it "returns conversations as entities" do
        expect(json.first).to be_representation_of(conversation)
          .with(conversation_presenter)
      end
    end

    context "invalid user" do
      before(:each) do
        get "/api/v1/conversations", user_id: -1
      end

      it "returns an empty array" do
        expect(json).to eq []
      end
    end
  end

  describe "POST conversations" do
    let(:subscribers) { [1, 2] }

    context "unique set of subscribers" do
      it "creates a new conversation" do
        expect {
          post "/api/v1/conversations", people_ids: subscribers
        }.to change(Conversation, :count).by(1)
      end

      it "returns newly created conversation" do
        post "/api/v1/conversations", people_ids: subscribers

        conversation = Conversation.last
        expect(json).to be_representation_of(conversation)
          .with(conversation_presenter)
      end
    end

    context "existing set of subscribers" do
      let!(:conversation) { create(:conversation, subscribers: subscribers) }

      it "returns existing conversation" do
        post "/api/v1/conversations", people_ids: subscribers
        expect(json).to be_representation_of(conversation)
          .with(conversation_presenter)
      end
    end
  end

  describe "GET :id/messages" do
    context "conversation exists" do
      let!(:conversation) do
        create(:conversation, :with_messages)
      end
      let(:last_message) { conversation.messages.last }

      it "returns most recent messages first" do
        get "/api/v1/conversations/#{conversation.id}/messages"
        expect(json.count).to eq conversation.messages.count
        expect(json.first).to be_representation_of(last_message)
          .with(message_presenter)
      end
    end

    context "conversation missing" do
      let(:missing_id) { "536b7ea44172747533000000" }

      it "responds with 404" do
        get "/api/v1/conversations/#{missing_id}/messages"
        expect(response.status).to eq 404
        expect(json).to include("error")
      end
    end
  end

  describe "POST :id/invite" do
    context "conversation exists" do
      let!(:conversation) { create(:conversation) }
      let(:subscribers) { [1,2] }

      before(:each) do
        post "/api/v1/conversations/#{conversation.id}/invite",
          people_ids: subscribers
      end

      it "adds new subscribers" do
        expect(conversation.reload.subscribers).to eq subscribers
      end

      it "returns conversation" do
        expect(json).to be_representation_of(conversation.reload)
          .with(conversation_presenter)
      end
    end

    context "conversation missing" do
      let(:missing_id) { "536b7ea44172747533000000" }

      it "responds with error" do
        post "/api/v1/conversations/#{missing_id}/invite", people_ids: []
        expect(response.status).to eq 400
        expect(json).to include("error")
      end
    end
  end
end