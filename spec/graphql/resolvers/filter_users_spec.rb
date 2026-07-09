require 'rails_helper'

RSpec.describe Resolvers::FilterUsers, type: :graphql do
  let(:query_ctx) { GraphQL::Query.new(RorWithGraphqlSchema, "{ __typename }").context }
  let(:resolver) { described_class.new(object: nil, context: query_ctx, field: nil) }

  describe '#resolve' do
    context 'when no filters applied' do
      it 'returns all the users' do
        create(:user, first_name: "Bruce Wayne")

        users = resolver.resolve

        expect(users.count).to eq(1)
        user = users.first
        expect(user.first_name).to eq('Bruce Wayne')
      end
    end

    context 'when first filter is applied' do
      it 'returns first 10 users' do
        create_list(:user, 10)

        users = resolver.resolve(first: 3)

        expect(users.count).to eq(3)
      end
    end

    context 'when filtered by role' do
      it 'returns users with specified role' do
        create_list(:user, 5, role: :admin)
        create_list(:user, 3, role: :client)

        users = resolver.resolve(role: :admin)

        expect(users.count).to eq(5)
        expect(users.admin.count).to eq(5)
      end
    end

    context 'when filtered by name' do
      it 'returns users with matching names' do
        create(:user, first_name: 'Bruce', last_name: 'Wayne')
        create(:user, first_name: 'Bruce', last_name: 'Lee')
        create(:user, first_name: 'Jackie', last_name: 'chan')

        users = resolver.resolve(search_by_name: 'Bruce')

        expect(users.count).to eq(2)
      end
    end

    it 'applies all the filters' do
      create(:user, first_name: 'Jackie', role: :admin)
      create(:user, first_name: 'Jackie', role: :client)
      create(:user, first_name: 'Jackie', last_name: 'Chan', role: :admin)

      users = resolver.resolve(role: :admin, search_by_name: 'Jackie', first: 1)

      expect(users.count).to eq(1)
    end
  end
end