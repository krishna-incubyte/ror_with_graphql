module Resolvers
  class SearchUsers < BaseResolver
    argument :name, String, required: true

    type [Types::UserType], null: false

    def resolve(name:)
      User.search(
        query: {
          wildcard: { name: "*#{name&.downcase}*" }
        }
      ).records
    end
  end
end
