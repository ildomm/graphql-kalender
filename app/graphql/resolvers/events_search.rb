require 'search_object/plugin/graphql'
require 'graphql/query_resolver'

class Resolvers::EventsSearch
  include SearchObject.module(:graphql)

  scope { Event.all }

  type types[Types::EventType]

  class EventFilter < ::Types::BaseInputObject
    argument :OR, [self], required: false
    argument :AND, [self], required: false
    argument :start_at_after, String, required: false
    argument :end_at_before, String, required: false
    argument :title_contains, String, required: false
    argument :url_contains, String, required: false
  end

  class EventOrderBy < ::Types::BaseEnum
    value 'createdAt_ASC'
    value 'createdAt_DESC'
  end

  option :filter, type: EventFilter, with: :apply_filter
  option :first, type: types.Int, with: :apply_first
  option :skip, type: types.Int, with: :apply_skip
  option :orderBy, type: EventOrderBy, default: 'createdAt_DESC'

  def apply_filter(scope, value)
    branches = normalize_filters(value).reduce { |a, b| a.or(b) }
    scope.merge branches
  end

  def normalize_filters(value, branches = [])
    scope = Event.all
    scope = scope.where('title LIKE ?', "%#{value[:title_contains]}%") if value[:title_contains]
    scope = scope.where('url LIKE ?', "%#{value[:url_contains]}%") if value[:url_contains]
    scope = scope.where('start_at >= ?', "#{value[:start_at_after]}") if value[:start_at_after]
    scope = scope.where('end_at <= ?', "#{value[:end_at_before]}") if value[:end_at_before]

    branches << scope

    value[:OR].reduce(branches) { |s, v| normalize_filters(v, s) } if value[:OR].present?
    value[:AND].reduce(branches) { |s, v| normalize_filters(v, s) } if value[:AND].present?

    branches
  end

  def apply_first(scope, value)
    scope.limit(value)
  end

  def apply_skip(scope, value)
    scope.offset(value)
  end

  def apply_orderBy_with_created_at_asc(scope) # rubocop:disable Style/MethodName
    scope.order('created_at ASC')
  end

  def apply_orderBy_with_created_at_desc(scope) # rubocop:disable Style/MethodName
    scope.order('created_at DESC')
  end

  def fetch_results
    # NOTE: Don't run QueryResolver during tests
    return super unless context.present?

    GraphQL::QueryResolver.run(Event, context, Types::EventType) do
      super
    end
  end
end
