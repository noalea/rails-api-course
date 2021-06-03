FactoryBot.define do
  factory :user do
    sequence(:login) { |n| "janedoe-#{n}" }
    name { "Jane Doe" }
    url { "https://example.com" }
    avatar_url { "https://example.com/avatar" }
    provider { "github" }
  end
end
