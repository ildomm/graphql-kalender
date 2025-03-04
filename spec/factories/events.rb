FactoryBot.define do
  factory :source do
    sequence(:name) { |n| "Source #{n}" }
    sequence(:url) { |n| "http://source#{n}.com" }
    config { '{}' }
  end

  factory :event do
    source
    sequence(:title) { |n| "Event #{n}" }
    sequence(:url) { |n| "http://example#{n}.com" }
    start_at { 1.day.from_now }
    end_at { 2.days.from_now }
  end
end
