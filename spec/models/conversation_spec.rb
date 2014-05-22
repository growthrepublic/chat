require 'spec_helper'

describe Conversation do
  describe "factories" do
    context "default" do
      subject { create(:conversation) }
      it { should be_valid }
    end

    context "with subscriber" do
      subject { create(:conversation, :with_subscriber) }
      it { should be_valid }
      its(:subscribers) { should_not be_empty }
    end
  end

  describe "#add_subscribers" do
    context "new subscriber" do
      let(:subscriber) { User.new(1) }
      subject { create(:conversation) }

      it "adds subscriber persistently" do
        subject.add_subscribers([subscriber])
        expect(subject.reload.subscribers).to include subscriber.id
      end
    end

    context "already a subscriber" do
      subject { create(:conversation, :with_subscriber) }
      let(:subscriber) { User.new(subject.subscribers.sample) }

      it "does not duplicate entry" do
        subject.add_subscribers([subscriber])
        expect(subject.reload.subscribers.count).to eq 1
      end
    end
  end

  describe "scopes" do
    describe ".subscribed_by" do
      let(:conversation) { create(:conversation) }
      let(:user)         { User.new(1) }

      context "user is the only subscriber" do
        before(:each) { conversation.add_subscribers([user]) }

        it "includes the conversation" do
          scope = described_class.subscribed_by(user)
          expect(scope.to_a).to include(conversation)
        end
      end

      context "user is one of the subscribers" do
        let(:other_user) { User.new(2) }

        before(:each) { conversation.add_subscribers([user, other_user]) }

        it "includes the conversation" do
          scope = described_class.subscribed_by(user)
          expect(scope.to_a).to include(conversation)
        end
      end
    end

    describe ".subscribed_by_all" do
      let!(:conversation) { create(:conversation) }
      let(:user)         { User.new(1) }

      context "user is the only subscriber" do
        before(:each) { conversation.add_subscribers([user]) }

        it "includes the conversation" do
          scope = described_class.subscribed_by_all([user])
          expect(scope.to_a).to include(conversation)
        end
      end

      context "user is one of the subscribers" do
        let(:other_user) { User.new(2) }

        before(:each) { conversation.add_subscribers([user, other_user]) }

        it "does not include the conversation" do
          scope = described_class.subscribed_by_all([user])
          expect(scope.to_a).to_not include(conversation)
        end
      end
    end
  end
end