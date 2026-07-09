require 'rails_helper'

RSpec.describe Types::PostType, type: :graphql_types do
  subject { described_class }

  it { is_expected.to have_field(:id).of_type("ID!") }
  it { is_expected.to have_field(:title).of_type("String") }
  it { is_expected.to have_field(:body).of_type("String") }
  it { is_expected.to have_field(:posted_on).of_type(GraphQL::Types::ISO8601Date) }
  it { is_expected.to have_field(:user).of_type("User!") }
end