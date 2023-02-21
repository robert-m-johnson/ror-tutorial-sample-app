# -*- mode: dockerfile -*-
FROM ruby:3.1.2-alpine3.16 as base

RUN mkdir /app
WORKDIR /app

# build-base - compilation of native extension
# postgresql14-dev - compilation of postgres gem
# tzdata - time zone data - possibly not needed for build stage?
RUN apk add --no-cache \
    build-base=0.5-r3 \
    postgresql14-dev=14.7-r0 \
    tzdata=2022f-r1 \
    && gem install bundler -v 2.3.14

COPY Gemfile Gemfile
COPY Gemfile.lock Gemfile.lock

RUN bundle config set --local without 'development test assets' \
    && bundle install

FROM base as assets

RUN bundle config set --local without 'test development' \
    && bundle install

COPY ./app/assets ./app/assets
COPY ./bin ./bin
COPY ./config ./config
COPY config.ru config.ru
COPY Rakefile Rakefile

RUN ./bin/rails assets:precompile

FROM ruby:3.1.2-alpine3.16 as app

RUN mkdir /app
WORKDIR /app

RUN apk add --no-cache libpq=14.7-r0 tzdata=2022f-r1

COPY --from=base /usr/local/bundle /usr/local/bundle
COPY Gemfile Gemfile
COPY Gemfile.lock Gemfile.lock

COPY config.ru config.ru
COPY Rakefile Rakefile

COPY ./app/assets ./app/assets
COPY ./bin ./bin
COPY ./config ./config
COPY --from=assets /app/public /app/public
RUN  ./bin/rails tmp:create

COPY ./lib ./lib
COPY ./app ./app
COPY ./db/migrate ./db/migrate
COPY ./db/schema.rb ./db/schema.rb
COPY ./db/seeds.rb ./db/seeds.rb

ENV RAILS_ENV=production
ENV RAILS_LOG_TO_STDOUT=true
CMD ["/app/bin/puma", "-C", "/app/config/puma.rb"]

# Build command:
# docker build --network host . -t ror-sample-app && docker run --network host --rm -p 3000 -it ror-sample-app

# Build & inspect:
# docker build --network host . -t ror-sample-app && docker run --network host --rm -it --entrypoint /bin/sh ror-sample-app
# docker build --network host . -t ror-sample-app --target assets && docker run --network host --rm -it --entrypoint /bin/sh ror-sample-app

# Alpine inspect:
# docker run --network host --rm -it --entrypoint /bin/sh alpine
