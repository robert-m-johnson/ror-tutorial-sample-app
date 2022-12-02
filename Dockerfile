FROM ruby:3.1.2-bullseye

RUN mkdir /app
WORKDIR /app

RUN gem install bundler -v 2.3.14

COPY Gemfile Gemfile
COPY Gemfile Gemfile.lock
RUN bundle install

COPY ./app ./app
COPY ./bin ./bin
COPY ./.bundle ./.bundle
COPY ./config ./config
# No DB file yet!
#COPY ./db/migrate ./db/migrate
COPY ./lib ./lib
COPY ./public ./public

COPY config.ru config.ru
COPY Rakefile Rakefile

RUN rails db:migrate

#CMD ["/bin/bash"]
CMD ["rails", "server"]

# Build command:
# docker build --network host . -t debug && docker run --network host --rm -p 3000 -it debug