FactoryBot.define do
  factory :source do
    sequence(:name) { |i| "Source #{i}" }
    sequence(:url) { |i| "www.site#{i}.com" }
  end
end
