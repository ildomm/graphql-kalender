FactoryBot.define do
  factory :link do
    sequence(:url) { |n| "http://example#{n}.com" }
    sequence(:description) { |n| "Link description #{n}" }
  end
end
