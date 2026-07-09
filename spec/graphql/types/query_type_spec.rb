require 'rails_helper'

RSpec.describe Types::QueryType, type: :grapghl do
  describe '#user' do
    it 'returns the user matching the given id' do
      user = create(:user)

      result = run_graphql_field('Query.user', nil, arguments: { id: user.id })

      expect(result).to eq(user)
    end

    it 'returns nil when no user matches' do
      result = run_graphql_field('Query.user', nil, arguments: { id: -1 })

      expect(result).to be_nil
    end
  end

  describe '#all_users' do
    it 'returns all users' do
      users = create_list(:user, 3)

      result = run_graphql_field('Query.allUsers', nil)

      expect(result).to match_array(users)
    end
  end

  describe '#test_field' do
    it 'returns the static greeting' do
      result = run_graphql_field('Query.testField', nil)

      expect(result).to eq('Hello World!')
    end
  end

  describe '#users_with_posts' do
    it 'returns only users who have posts' do
      user_with_post = create(:user, :with_post)
      user_without_post = create(:user)

      result = run_graphql_field('Query.usersWithPosts', nil)

      expect(result).to contain_exactly(user_with_post)
      expect(result).not_to include(user_without_post)
    end
  end

  describe '#filter_user' do
    it 'filters users by name' do
      matching_user = create(:user, first_name: 'Bruce')
      other_user = create(:user, first_name: 'Alfred')

      result = run_graphql_field('Query.filterUser', nil, arguments: { search_by_name: 'Bruce' })

      expect(result).to contain_exactly(matching_user)
      expect(result).not_to include(other_user)
    end

    it 'filters users by role' do
      admin = create(:user, role: :admin)
      other_user = create(:user, role: :client)

      result = run_graphql_field('Query.filterUser', nil, arguments: { role: 'admin' })

      expect(result).to contain_exactly(admin)
      expect(result).not_to include(other_user)
    end

    it 'limits results using first' do
      create_list(:user, 3)

      result = run_graphql_field('Query.filterUser', nil, arguments: { first: 2 })

      expect(result.size).to eq(2)
    end

    it 'returns all users when no arguments are given' do
      users = create_list(:user, 2)

      result = run_graphql_field('Query.filterUser', nil)

      expect(result).to match_array(users)
    end
  end
end