FactoryBot.define do
  factory :event do
    source
    sequence(:url) { |i| "www.site#{i}.com" }
    sequence(:title) { |i| "title#{i}" }
    sequence(:start_at) { |i| Time.now }
    sequence(:end_at) { |i| Time.now }
  end
end
