require 'rails_helper'

RSpec.describe Resolvers::SearchUsers, type: :graphql do
  let(:query_ctx) { GraphQL::Query.new(RorWithGraphqlSchema, "{ __typename }").context }
  let(:resolver) { described_class.new(object: nil, context: query_ctx, field: nil) }

  describe '#resolve' do
    context 'when the name matches existing users' do
      it 'returns users whose full name matches the given name' do
        create(:user, first_name: 'Bruce', last_name: 'Wayne')
        create(:user, first_name: 'Bruce', last_name: 'Lee')
        create(:user, first_name: 'Jackie', last_name: 'Chan')

        users = resolver.resolve(name: 'Bruce')

        expect(users.count).to eq(2)
      end

      it 'returns users whose name matches a partial (single-word) search term' do
        create(:user, first_name: 'Bruce', last_name: 'Wayne')
        create(:user, first_name: 'Alfred', last_name: 'Pennyworth')

        users = resolver.resolve(name: 'Wayne')

        expect(users.count).to eq(1)
        expect(users.first.last_name).to eq('Wayne')
      end
    end

    context 'when no users match the given name' do
      it 'returns an empty list' do
        create(:user, first_name: 'Bruce', last_name: 'Wayne')

        users = resolver.resolve(name: 'Nonexistent')

        expect(users).to be_empty
      end
    end
  end
end
