# README

# Dependencies

- ruby 3.4.5
- rails 8.0.3
- Postgres
- Docker Desktop

# Server startup script

```ruby
  # Build the app
  docker build -t rails-app .

  # run the app
  docker run --rm -p 3000:3000 -e DATABASE_URL="postgresql://user:password@host.docker.internal:5432/db_name" -e MASTER_KEY=MASTER_KEY rails-app
```

