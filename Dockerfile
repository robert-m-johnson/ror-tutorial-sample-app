# -*- mode: dockerfile -*-
FROM ruby:3.1.2-alpine3.16 as build

RUN mkdir /app
WORKDIR /app

RUN apk add --update build-base postgresql-dev tzdata

RUN gem install bundler -v 2.3.14

COPY Gemfile Gemfile
COPY Gemfile.lock Gemfile.lock

RUN bundle config set --local without 'test development'
RUN bundle install

FROM ruby:3.1.2-alpine3.16

RUN mkdir /app
WORKDIR /app

RUN apk add --update libpq tzdata \
    && rm -rf /var/cache/apk

COPY --from=build /usr/local/bundle /usr/local/bundle
COPY Gemfile Gemfile
COPY Gemfile.lock Gemfile.lock

COPY config.ru config.ru
COPY Rakefile Rakefile

COPY ./bin ./bin
COPY ./config ./config
COPY ./lib ./lib

COPY ./app/assets ./app/assets
RUN ./bin/rails assets:precompile

COPY ./app ./app
COPY ./db/migrate ./db/migrate
COPY ./db/schema.rb ./db/schema.rb
COPY ./db/seeds.rb ./db/seeds.rb

RUN ./bin/rails tmp:create

ENV RAILS_ENV=production
ENV RAILS_LOG_TO_STDOUT=true
CMD ["/app/bin/puma", "-C", "/app/config/puma.rb"]

# Build command:
# docker build --network host . -t ror-sample-app && docker run --network host --rm -p 3000 -it ror-sample-app

# Build & inspect:
# docker build --network host . -t ror-sample-app && docker run --network host --rm -it --entrypoint /bin/sh ror-sample-app

# Alpine inspect:
# docker run --network host --rm -it --entrypoint /bin/sh alpine
