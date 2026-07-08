# frozen_string_literal: true

module Types
  class UserType < Types::BaseObject
    field :id, ID, null: false
    field :first_name, String, null: false
    field :last_name, String
    field :dob, GraphQL::Types::ISO8601Date
    field :gender, String, null: false
    field :role, String, null: false
    field :posts, [Types::PostType]
  end
end
