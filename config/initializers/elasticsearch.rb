Elasticsearch::Model.client = Elasticsearch::Client.new(
  host: ENV.fetch("ELASTICSEARCH_URL", "https://localhost:9200"),
  user: ENV.fetch("ELASTIC_USERNAME", "elastic"),
  password: ENV.fetch("ELASTIC_PASSWORD"),
  transport_options: {
    ssl: {
      ca_file: ENV.fetch("ELASTIC_CA_CERT_PATH", "~/"),
      verify: true
    }
  },
  log: Rails.env.development?
)