require "feature_spec_helper"

feature "websocket conversation" do
  given(:users) do
    2.times.map { |n| User.new(n + 1) }
  end

  given(:clients) do
    users.map { |u| PageObjects::ChatClient.new(u.id) }
  end

  given!(:conversation) do
    create(:conversation, subscribers: users.map(&:id))
  end

  background do
    open_test_fixture("websocket_conversation", data: {
      subscribers:     conversation.subscribers,
      conversation_id: conversation.id.to_s,
      server:          server_host_with_port })
  end

  scenario "bidirectional communication between subscribers", js: true do
    clients.first.send_message("first")
    clients.each do |client|
      expect(client.received_message?("first")).to be true
    end

    clients.last.send_message("second")
    clients.each do |client|
      expect(client.received_message?("second")).to be true
    end
  end
end