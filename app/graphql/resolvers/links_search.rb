require 'search_object/plugin/graphql'
require 'graphql/query_resolver'

class Resolvers::LinksSearch < GraphQL::Schema::Resolver
  include SearchObject.module(:graphql)

  scope { Link.all }

  type [Types::LinkType], null: false

  class LinkFilter < ::Types::BaseInputObject
    argument :OR, [self], required: false
    argument :description_contains, String, required: false
    argument :url_contains, String, required: false
  end

  class LinkOrderBy < ::Types::BaseEnum
    value 'createdAt_ASC'
    value 'createdAt_DESC'
  end

  argument :filter, LinkFilter, required: false
  argument :first, Integer, required: false
  argument :skip, Integer, required: false
  argument :orderBy, LinkOrderBy, required: false, default_value: 'createdAt_DESC'

  def resolve(filter: nil, first: nil, skip: nil, orderBy: nil)
    scope = Link.all
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
    scope = Link.all
    scope = scope.where('description LIKE ?', "%#{value[:description_contains]}%") if value[:description_contains]
    scope = scope.where('url LIKE ?', "%#{value[:url_contains]}%") if value[:url_contains]

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
