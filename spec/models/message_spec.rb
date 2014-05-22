require "spec_helper"

describe Message do
  describe ".from_attributes_by_id" do
    context "existing message" do
      let!(:conversations) do
        create_list(:conversation, 2, :with_messages, :with_subscribers)
      end

      let(:conversation)  { conversations.sample }
      let(:message)       { conversation.messages.sample.reload }

      let(:find_message) do
        described_class.from_attributes_by_id(message.id.to_s,
          conversation_id: conversation.id.to_s)
      end

      it "instantiates appropriate message" do
        expect(find_message.id).to eq message.id
      end

      it "sets message's attributes" do
        expect(find_message.attributes).to eq message.attributes
      end

      it "sets conversation" do
        expect(find_message.conversation.id).to eq conversation.id
      end

      it "sets conversation's subscribers" do
        expect(find_message.conversation.subscribers).to eq conversation.subscribers
      end
    end

    context "message not found" do
      let(:find_message) do
        described_class.from_attributes_by_id('536aa2154172742db60d0000',
          conversation_id: '536b7ea44172747533000000')
      end

      it "returns nil" do
        expect(find_message).to be_nil
      end
    end
  end
end