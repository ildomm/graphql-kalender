module Types
  class SourceType < BaseNode
    field :id, ID, null: false
    field :created_at, DateTimeType, null: false
    field :name, String, null: false
    field :url, String, null: false
  end
end
