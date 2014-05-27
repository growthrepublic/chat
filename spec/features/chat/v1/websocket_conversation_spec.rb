require "feature_spec_helper"

feature "websocket conversation" do
  given(:subscribers) do
    2.times.map { |n| User.new(n + 1) }
  end

  given(:connected_subscribers) do
    subscribers.map { |u| PageObjects::ChatClient.new(u.id) }
  end

  given!(:conversation) do
    create(:conversation, subscribers: subscribers.map(&:id))
  end

  background do
    open_fixture("websocket_conversation", data: {
      subscribers:     conversation.subscribers,
      conversation_id: conversation.id.to_s,
      server:          server_host_with_port })
  end

  scenario "bidirectional communication between subscribers", js: true do
    connected_subscribers.first.send_message("first")
    connected_subscribers.each do |client|
      expect(client.received_message?("first")).to be true
    end

    connected_subscribers.last.send_message("second")
    connected_subscribers.each do |client|
      expect(client.received_message?("second")).to be true
    end
  end
end