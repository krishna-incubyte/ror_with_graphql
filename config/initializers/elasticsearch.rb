Elasticsearch::Model.client = Elasticsearch::Client.new(
  host: ENV.fetch("ELASTICSEARCH_URL", "http://localhost:9200"),
  user: ENV.fetch("ELASTIC_USERNAME", "elastic"),
  password: ENV.fetch("ELASTIC_PASSWORD"),
  log: Rails.env.development?
)