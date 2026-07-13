# syntax=docker/dockerfile:1

# Build stage

FROM ruby:3.4.5-slim AS build
RUN apt-get update -qq
RUN apt-get install -y build-essential
RUN apt-get install -y libpq-dev
RUN apt-get install -y git
RUN apt-get install -y curl

WORKDIR /staging

COPY Gemfile Gemfile.lock ./

ENV BUNDLE_PATH="/usr/local/bundle"

RUN bundle install

COPY . .

# ---- Final stage ----
FROM ruby:3.4.5-slim AS final

ENV GEM_HOME="/usr/local/bundle/ruby/3.4.0"
ENV BUNDLE_PATH="/usr/local/bundle"
ENV PATH="/usr/local/bundle/ruby/3.4.0/bin:${PATH}"

RUN apt-get update -qq
RUN apt-get install -y libpq-dev

WORKDIR /staging

COPY --from=build /usr/local/bundle /usr/local/bundle
COPY --from=build /staging /staging

EXPOSE 3000
CMD ["rails", "server", "-b", "0.0.0.0"]