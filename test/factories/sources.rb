FactoryBot.define do
  factory :source do
    sequence(:name) { |i| "Source #{i}" }
    sequence(:url) { |i| "www.site#{i}.com" }
    sequence(:config) { |i| "{}" }
  end
end
