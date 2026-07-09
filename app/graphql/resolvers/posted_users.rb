module Resolvers
  class PostedUsers < BaseResolver
    description 'Find users who have posts'

    type [Types::UserType], null: false

    def resolve
      User.where(id: Post.pluck(:user_id))
    end
  end
end