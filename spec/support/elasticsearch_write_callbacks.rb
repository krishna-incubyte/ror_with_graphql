# The Searchable concern's after_commit callbacks (index_document, update_document,
# delete_document) perform real HTTP requests to Elasticsearch on every create/update/
# destroy. Specs under spec/graphql/resolvers/ intentionally exercise real Elasticsearch
# search behavior (see filter_users_spec.rb, search_users_spec.rb), so those are left
# untouched and are not tagged here.
#
# Every other spec that persists a User/Post only needs the record saved and has no
# interest in search behavior, so it opts in to stubbed ES write callbacks by tagging
# its example group with `skip_es_callbacks: true`, e.g.:
#
#   RSpec.describe Mutations::CreateUser, type: :graphql, skip_es_callbacks: true do
#
RSpec.configure do |config|
  config.before(:each, skip_es_callbacks: true) do
    allow_any_instance_of(Elasticsearch::Model::Proxy::InstanceMethodsProxy).to receive(:index_document)
    allow_any_instance_of(Elasticsearch::Model::Proxy::InstanceMethodsProxy).to receive(:update_document)
    allow_any_instance_of(Elasticsearch::Model::Proxy::InstanceMethodsProxy).to receive(:delete_document)
  end
end
