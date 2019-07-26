module Types
  class SourceType < BaseNode
    field :created_at, DateTimeType, null: false
    field :name, String, null: false
    field :url, String, null: false
  end
end
