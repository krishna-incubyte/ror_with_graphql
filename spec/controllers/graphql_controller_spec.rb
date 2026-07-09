require 'rails_helper'

RSpec.describe GraphqlController, type: :controller do
  let(:user) { create :user, first_name: 'Bruce', last_name: 'Wayne' }
  let(:query) {
    <<~GQL
      query {
        user(id: #{user.id}) {
          firstName
          lastName
        }
      }
    GQL
  }
  let(:make_request) { post 'execute', params: { query: query } }

  describe '#execute' do
    it 'returns details of user' do
      make_request

      expect(response).to have_http_status(:ok)
      data = JSON.parse(response.body)["data"]
      expect(data).to eq({"user" => {"firstName" => "Bruce", "lastName" => "Wayne"}})
    end
  end
end