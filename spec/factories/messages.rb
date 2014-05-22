FactoryGirl.define do
  sequence :message_sender_id do |n|
    n
  end

  factory :message do
    type "message"
    body "content"
    user_id { generate(:message_sender_id) }
    conversation
  end
end