require 'rails_helper'

RSpec.describe Resolvers::PostedUsers, type: :graphql, skip_es_callbacks: true do
  let(:query_ctx) { GraphQL::Query.new(RorWithGraphqlSchema, "{ __typename }").context }
  let(:resolver) { described_class.new(object: nil, context: query_ctx, field: nil) }

  describe '#resolve' do
    it 'returns users with posts' do
      posted_user = create :user, :with_post
      user = create :user

      users = resolver.resolve

      expect(users).to include(posted_user)
      expect(users).not_to include(user)
    end
  end
end