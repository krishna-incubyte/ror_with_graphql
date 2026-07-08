module Resolvers
  class PostedUsers < BaseResolver
    type [Types::UserType], null: false

    def resolve
      User.where(id: Post.pluck(:user_id))
    end
  end
end