FROM ruby:2.7.4

ENV BUNDLER_VERSION=2.2.20

RUN apt-get update && \
    apt-get install -y --no-install-recommends nodejs npm tmux

RUN gem install bundler -v 2.2.20

WORKDIR /app

COPY Gemfile Gemfile.lock ./

RUN bundle check || bundle install

COPY package.json ./

# RUN npm install

COPY . ./
ENTRYPOINT ["./entrypoints/docker-entrypoint.sh"]
