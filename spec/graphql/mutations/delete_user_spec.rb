require 'rails_helper'

RSpec.describe Mutations::DeleteUser, type: :graphql, skip_es_callbacks: true do
  let(:query_ctx) { GraphQL::Query.new(RorWithGraphqlSchema, "{ __typename }").context }
  let(:mutation) { described_class.new(object: nil, context: query_ctx, field: nil) }

  describe '#resolve' do
    it 'destroys the matching user' do
      user = create(:user)

      result = mutation.resolve(id: user.id)

      expect(result[:success]).to include(user.first_name)
      expect(result[:errors]).to be_empty
      expect(User.exists?(user.id)).not_to be
    end

    it 'returns an error when the user cannot be found' do
      result = mutation.resolve(id: -1)

      expect(result[:success]).to be_nil
      expect(result[:errors]).to eq(['User not found'])
    end
  end
end
