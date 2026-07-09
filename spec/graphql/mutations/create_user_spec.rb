require 'rails_helper'

RSpec.describe Mutations::CreateUser, type: :graphql do
  let(:query_ctx) { GraphQL::Query.new(RorWithGraphqlSchema, "{ __typename }").context }
  let(:mutation) { described_class.new(object: nil, context: query_ctx, field: nil) }

  describe '#resolve' do
    let(:attributes) do
      {
        first_name: 'Bruce',
        last_name: 'Wayne',
        dob: Date.parse('1980-01-01'),
        role: 'admin',
        gender: 'male'
      }
    end

    it 'creates a user with the given attributes' do
      expect {
        mutation.resolve(**attributes)
      }.to change(User, :count).by(1)
      user = User.find_by(**attributes)
      expect(user).to be
    end

    it 'raises when required attributes are missing' do
      expect {
        mutation.resolve(**attributes.merge(gender: nil))
      }.to raise_error(ActiveRecord::NotNullViolation)
    end
  end
end
