require 'factory_bot'

if Event.count.zero?
  10.times do
    FactoryBot.create :event
  end
end