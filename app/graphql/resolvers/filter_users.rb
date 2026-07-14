module Resolvers
  class FilterUsers < BaseResolver
    argument :first, Integer, required: false
    argument :search_by_name, String, required: false
    argument :role, String, required: false

    type [Types::UserType], null: false

    def resolve(first: nil, search_by_name: nil, role: nil)
      users = User.all
      users = User.search(search_by_name).records if search_by_name.present?
      users = users.where(role: role) if role
      users = users.limit(first) if first
      users
    end
  end
end