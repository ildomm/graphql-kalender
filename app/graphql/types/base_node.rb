module Types
  class BaseNode < BaseObject
    implements GraphQL::Types::Relay::Node

    global_id_field :id
  end
end
