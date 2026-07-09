require 'rails_helper'

RSpec.describe 'routes', type: :routing do
  it { expect(post('/graphql')).to route_to('graphql#execute') }
end