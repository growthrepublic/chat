# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :conversation do
    trait :with_subscriber do
      subscribers [1]
    end

    trait :with_subscribers do
      subscribers [1, 2]
    end

    trait :with_message do
      after(:create) do |instance|
        create(:message, conversation: instance)
      end
    end

    trait :with_messages do
      after(:create) do |instance|
        create_list(:message, 2, conversation: instance)
      end
    end
  end
end