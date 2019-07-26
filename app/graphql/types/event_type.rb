module Types
  class EventType < BaseNode
    field :created_at, DateTimeType, null: false
    field :start_at, DateTimeType, null: false
    field :end_at, DateTimeType, null: false
    field :url, String, null: false
    field :title, String, null: false
    field :posted_by, SourceType, null: false, method: :source
  end
end
