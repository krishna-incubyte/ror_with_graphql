require 'rails_helper'

RSpec.describe Types::MutationType, type: :grapghl do
  describe '#create_user' do
    it 'creates a user with the given attributes' do
      user = run_graphql_field('Mutation.createUser', nil, arguments: {
        input: {
          first_name: 'Bruce',
          last_name: 'Wayne',
          dob: '1980-01-01',
          role: 'admin',
          gender: 'male'
        }
      })

      expect(user).to be_persisted
      expect(user.first_name).to eq('Bruce')
      expect(user.role).to eq('admin')
    end
  end

  describe '#update_user' do
    it 'updates the matching user with the given attributes' do
      user = create(:user, first_name: 'Test')

      result = run_graphql_field('Mutation.updateUser', nil, arguments: {
        input: {
          id: user.id,
          first_name: 'Alfred',
          last_name: user.last_name,
          dob: '1975-05-05',
          role: user.role,
          gender: user.gender
        }
      })

      user.reload
      expect(user.first_name).to eq('Alfred')
    end
  end

  describe '#delete_user' do
    it 'destroys the matching user' do
      user = create(:user)

      result = run_graphql_field('Mutation.deleteUser', nil, arguments: { input: { id: user.id } })

      expect(result[:success]).to include(user.first_name)
      expect(result[:errors]).to be_empty
      expect(User.exists?(user.id)).not_to be
    end
  end

  describe '#test_field' do
    it 'returns the static greeting' do
      result = run_graphql_field('Mutation.testField', nil)

      expect(result).to eq('Hello World')
    end
  end
end
