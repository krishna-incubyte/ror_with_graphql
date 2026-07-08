# frozen_string_literal: true

module Types
  class PostType < Types::BaseObject
    field :id, ID, null: false
    field :title, String
    field :body, String
    field :posted_on, GraphQL::Types::ISO8601Date
    field :user, Types::UserType, null: false
  end
end
