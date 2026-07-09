require 'rails_helper'

RSpec.describe Types::UserType, type: :graphql_types do
  subject { described_class }

  it { is_expected.to have_field(:id).of_type("ID!") }
  it { is_expected.to have_field(:first_name).of_type("String!") }
  it { is_expected.to have_field(:last_name).of_type("String") }
  it { is_expected.to have_field(:dob).of_type(GraphQL::Types::ISO8601Date) }
  it { is_expected.to have_field(:gender).of_type("String!") }
  it { is_expected.to have_field(:role).of_type("String!") }
end