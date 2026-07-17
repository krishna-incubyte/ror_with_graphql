## Context: Search users by name (GraphQL query)

Analysis method: text-based pattern matching (LSP not attempted — Ruby/Solargraph not available in this tool environment; fallback used throughout)

### Project Structure
- **Stack**: Ruby on Rails 8.0.3, `graphql-ruby` ~> 2.6, PostgreSQL, Redis (cache + session store), Elasticsearch 8.15 (via `elasticsearch-model` + `elasticsearch-rails` gems)
- **Build**: Bundler; `compose.yaml` orchestrates db/redis/elasticsearch/web for local dev
- **Layout**: Standard Rails app dir layout, plus `app/graphql/{types,resolvers,mutations}` for the GraphQL layer. GraphQL-only app — `config/routes.rb` exposes only `POST /graphql`.
- **Key dependencies**: `graphql`, `elasticsearch-model`, `elasticsearch-rails`, `redis`, `redis-session-store`; test-only: `rspec-rails`, `factory_bot_rails`, `vcr`+`webmock`, `shoulda-matchers`, `rspec-graphql_matchers`, `simplecov`

### Architecture Pattern
- Simple/thin, feature-organized GraphQL layer (not classic MVC, no REST controllers). Resolver objects (`Resolvers::BaseResolver < GraphQL::Schema::Resolver`) encapsulate query logic and are wired into `Types::QueryType` via `field :x, resolver: Resolvers::X`.
- `Resolvers::BaseResolver` is an empty subclass — no shared helper methods, no DI, resolvers get nothing beyond graphql-ruby's own `GraphQL::Schema::Resolver` machinery.
- Dependency direction: `Types::QueryType` → `Resolvers::*` → `ActiveRecord models` (`User`, `Post`) → Elasticsearch (via `Searchable` concern for `User`). No service/repository layer in between.

### Test Infrastructure
- **Framework**: RSpec, with `type: :grapghl` (typo, consistently used everywhere — see Tidy) used for resolver specs.
- **Location**: `spec/graphql/resolvers/*_spec.rb`, `spec/graphql/types/query_type_spec.rb` (field-level specs via `run_graphql_field`), `spec/models/user_spec.rb`.
- **Naming**: `*_spec.rb`, mirrors `app/` structure exactly.
- **Run command**: `bundle exec rspec`
- **Mocking**: FactoryBot for fixtures. **No ES mocking/stubbing found** — `filter_users_spec.rb` calls `resolver.resolve(search_by_name: ...)` directly against a real Elasticsearch instance (`compose.yaml` provisions elasticsearch:8.15.0). **CI does not run RSpec at all** (`.github/workflows/ci.yml` only runs brakeman + rubocop) — ES-dependent specs are not verified by any pipeline today.

### Project Conventions
- No CLAUDE.md. RuboCop via `rubocop-rails-omakase` (default Rails house style). Commits are short imperative one-liners.
- Resolvers build up an ActiveRecord relation via conditional chaining (`users = users.where(...) if ...`).

### Change Area
- `app/graphql/resolvers/filter_users.rb` — **already does name search** via `User.search(search_by_name).records`, plus `role` filter and `first` limit. Closest existing analog. Developer confirmed (via AskUserQuestion) they want a **new, dedicated GraphQL query field** `searchUsers`, separate from `filterUser`.
- `app/models/concerns/searchable.rb` — minimal concern, just mixes in `Elasticsearch::Model` + `Elasticsearch::Model::Callbacks`. Does NOT wrap `search` with custom options. `User.search(query)` with a plain string builds a default query_string search — no fuzzy matching, pagination, or highlighting unless the caller passes a full ES query hash.
- `app/graphql/types/user_type.rb` — existing `UserType`, likely the return type for the new field.
- `app/graphql/types/query_type.rb` — where the new field will be registered (pattern: `field :search_users, resolver: Resolvers::SearchUsers`).
- Files to create: `app/graphql/resolvers/search_users.rb`, `spec/graphql/resolvers/search_users_spec.rb`. File to modify: `app/graphql/types/query_type.rb`.
- No auth/authorization layer anywhere in the GraphQL app — consistent, no auth expected for this field either. Rails.cache is used elsewhere (`User#posts_count`) but not in resolvers — caching not an existing pattern for this kind of query.

### Tidy Opportunities (not acted on — flagged only)
- `Resolvers::AggregateUsers` has no spec file (pattern of partial coverage in resolver dir).
- CI does not run RSpec at all.
- `type: :grapghl` typo is baked into rails_helper.rb and all existing specs — new specs should follow the existing (mis-spelled) convention for consistency rather than "fixing" it in isolation.

### Design System
- UI-involved: no. GraphQL API backend only, no frontend.

## Context: Isolate test Docker stack from dev Docker stack

- `compose.yaml` (tracked, unchanged) defines `db` (postgres:17, host port 5430), `redis` (host port 6380), `elasticsearch` (host port 9200), `web`. Fixed host port mappings, no env-var parameterization of ports.
- Docker project name today defaults to the directory name `ror_with_graphql` (seen in running container names `ror_with_graphql-db-1`, etc.) — this is the dev stack, currently running with real dev data (and, as of the searchUsers verification work, some stale test documents that leaked into it — the reason for this new isolation request).
- `.env` (tracked... actually gitignored, but present locally) — dev env vars: `DATABASE_URL` → `ror_with_graphql_development` db, internal hostnames (`db`, `redis`, `elasticsearch`) for use by the `web` service on the compose network.
- `.docker.test.env` and `.test.env` (untracked, gitignored via `/.env*` in .gitignore) already exist locally (created ad hoc during the searchUsers slice's verification) with test-appropriate values: `DATABASE_URL` → `ror_with_graphql_test` db, `RAILS_ENV=test`, internal hostnames for db/redis/es. Developer wants `.docker.test.env` specifically to be the one used for the isolated test docker stack's env vars — reuse/finalize it rather than create a new file.
- Developer's decisions (via AskUserQuestion):
  - Isolation approach: use a **separate Docker Compose project name** (not a separate compose file) — same `compose.yaml`, different `-p`/`COMPOSE_PROJECT_NAME` so volumes/networks are auto-namespaced separately from dev (e.g. dev → `ror_with_graphql_db_data`, test → `ror_with_graphql_test_db_data`).
  - Ports: dev and test stacks will **not run concurrently** — no need to parameterize/change compose.yaml's hardcoded host ports (5430/6380/9200). Developer will stop one stack before starting the other.
  - Env file: use `.docker.test.env` as the single source of env vars for the isolated test stack (including setting `COMPOSE_PROJECT_NAME` inside it, so `docker compose --env-file .docker.test.env ...` alone establishes the isolated project without needing a `-p` flag on every command).
- No compose.yaml changes needed. No rspec/application code changes needed — this is pure docker/env tooling.
