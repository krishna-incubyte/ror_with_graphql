module Resolvers
  class AggregateUsers < BaseResolver
    description 'aggregations'

    type GraphQL::Types::JSON, null: false

    def resolve
      response = User.search(
        size: 0,
        query: {
          bool: {
            filter: [
              { range: { dob: { gt: 10.years.ago.to_date } } }
            ]
          }
        },
        aggs: {
          by_group: {
              filters: {
                filters: {
                  male_users:  { match: { gender: "male" } },
                  admin_users: { match: { role: "admin" } }
                }
              }
            }
        }
      )
      response.aggregations["by_group"]["buckets"]
    end
  end
end