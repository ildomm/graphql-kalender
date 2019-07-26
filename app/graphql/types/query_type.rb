module Types
  class QueryType < BaseObject
    field :node, field: GraphQL::Relay::Node.field
    field :nodes, field: GraphQL::Relay::Node.plural_field

    field :all_links, function: Resolvers::LinksSearch
    field :_all_links_meta, QueryMetaType, null: false

    def _all_links_meta
      Link.count
    end

    field :all_events, function: Resolvers::EventsSearch
    field :_all_events_meta, QueryMetaType, null: false

    def _all_events_meta
      Event.count
    end

    field :sources, [Types::SourceType], null: false
    def sources
      Source.all
    end

    field :source, Types::SourceType, null: false do
      argument :id, Int, required: false
    end
    def source(id:)
      Source.find(id)
    end

  end
end
