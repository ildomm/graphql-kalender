require 'search_object/plugin/graphql'
require 'graphql/query_resolver'

class Resolvers::EventsSearch < GraphQL::Schema::Resolver
  include SearchObject.module(:graphql)

  scope { Event.all }

  type [Types::EventType], null: false

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

  argument :filter, EventFilter, required: false
  argument :first, Integer, required: false
  argument :skip, Integer, required: false
  argument :orderBy, EventOrderBy, required: false, default_value: 'createdAt_DESC'

  def resolve(filter: nil, first: nil, skip: nil, orderBy: nil)
    scope = Event.all
    scope = apply_filter(scope, filter) if filter
    scope = apply_order(scope, orderBy)
    scope = apply_skip(scope, skip) if skip
    scope = apply_first(scope, first) if first
    scope.to_a
  end

  private

  def apply_filter(scope, value)
    return scope unless value

    branches = normalize_filters(value).reduce { |a, b| a.or(b) }
    scope.merge(branches)
  end

  def normalize_filters(value, branches = [])
    scope = Event.all
    scope = scope.where('title LIKE ?', "%#{value[:title_contains]}%") if value[:title_contains]
    scope = scope.where('url LIKE ?', "%#{value[:url_contains]}%") if value[:url_contains]
    scope = scope.where('start_at >= ?', value[:start_at_after]) if value[:start_at_after]
    scope = scope.where('end_at <= ?', value[:end_at_before]) if value[:end_at_before]

    branches << scope

    value[:OR].reduce(branches) { |s, v| normalize_filters(v, s) } if value[:OR].present?

    branches
  end

  def apply_first(scope, value)
    scope.limit(value)
  end

  def apply_skip(scope, value)
    scope.offset(value)
  end

  def apply_order(scope, value)
    case value
    when 'createdAt_ASC'
      scope.order('created_at ASC')
    when 'createdAt_DESC'
      scope.order('created_at DESC')
    else
      scope.order('created_at DESC')
    end
  end
end
