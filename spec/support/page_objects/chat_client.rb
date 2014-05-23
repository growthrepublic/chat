module PageObjects
  class ChatClient
    include Capybara::DSL

    def initialize(id)
      @id = id
    end

    def send_message(msg = "test")
      within_user_section do
        fill_in "message_text", with: msg
        click_button "submit-message"
      end
    end

    def received_message?(msg = "test")
      user_section.has_text? %{"body":"#{msg}"}
    end

    private

    def within_user_section(&block)
      within(user_section, &block)
    end

    def user_section
      find "#user-#{@id}"
    end
  end
end