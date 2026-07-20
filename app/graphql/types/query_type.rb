# frozen_string_literal: true

module Types
  class QueryType < Types::BaseObject

    field :user, Types::UserType, null: true do
      argument :id, ID, required: true
    end

    field :all_users, [Types::UserType], null: false

    field :users_with_posts, resolver: Resolvers::PostedUsers

    field :filter_user, resolver: Resolvers::FilterUsers

    field :search_users, resolver: Resolvers::SearchUsers

    field :aggregations, resolver: Resolvers::AggregateUsers

    def user(id:)
      User.find_by(id: id)
    end

    def all_users
      User.includes(:posts).all
    end
  end
end
