require 'rails_helper'

RSpec.describe Mutations::UpdateUser, type: :graphql do
  let(:query_ctx) { GraphQL::Query.new(RorWithGraphqlSchema, "{ __typename }").context }
  let(:mutation) { described_class.new(object: nil, context: query_ctx, field: nil) }

  describe '#resolve' do
    it 'updates the matching user with the given attributes' do
      user = create(:user, first_name: 'Bruce')

      mutation.resolve(
        id: user.id,
        first_name: 'Alfred',
        last_name: user.last_name,
        dob: Date.parse('1975-05-05'),
        role: user.role,
        gender: user.gender
      )

      expect(user.reload.first_name).to eq('Alfred')
    end

    it 'returns an execution error when the user cannot be found' do
      result = mutation.resolve(
        id: -1,
        first_name: 'Alfred',
        last_name: 'Pennyworth',
        dob: Date.parse('1975-05-05'),
        role: 'admin',
        gender: 'male'
      )

      expect(result).to be_a(GraphQL::ExecutionError)
      expect(result.message).to eq('User not found')
    end
  end
end
