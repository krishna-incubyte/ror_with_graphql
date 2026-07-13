# syntax=docker/dockerfile:1

FROM ruby:3.4.5-slim

RUN apt-get update -qq

RUN apt-get install -y build-essential

RUN apt-get install -y libpq-dev

RUN apt-get install -y git

RUN apt-get install -y curl

WORKDIR /staging

COPY Gemfile Gemfile.lock ./

RUN bundle install

COPY . .

EXPOSE 3000
CMD ["rails", "server", "-b", "0.0.0.0"]