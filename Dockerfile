# -*- mode: dockerfile -*-
FROM ruby:3.1.2-bullseye

RUN mkdir /app
WORKDIR /app

RUN gem install bundler -v 2.3.14

COPY Gemfile Gemfile
COPY Gemfile.lock Gemfile.lock

RUN bundle config set --local without 'test development'
RUN bundle install

COPY config.ru config.ru
COPY Rakefile Rakefile

COPY ./bin ./bin
COPY ./app ./app
COPY ./config ./config
COPY ./lib ./lib
COPY ./public ./public
COPY ./db/migrate ./db/migrate
COPY ./db/schema.rb ./db/schema.rb
COPY ./db/seeds.rb ./db/seeds.rb

RUN ./bin/rails tmp:create

# #CMD ["./bin/rails", "server", "--binding=0.0.0.0"]
ENV RAILS_ENV=production
CMD ["/app/bin/puma", "-C", "/app/config/puma.rb"]

# Build command:
# docker build --network host . -t ror-sample-app && docker run --network host --rm -p 3000 -it ror-sample-app

# Build & inspect:
# docker build --network host . -t ror-sample-app && docker run --network host --rm -it --entrypoint /bin/sh ror-sample-app

# Alpine inspect:
# docker run --network host --rm -it --entrypoint /bin/sh alpine
