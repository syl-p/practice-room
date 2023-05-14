FROM ruby:2.7.4

ENV BUNDLER_VERSION=2.2.20

RUN apt-get update && \
    apt-get install -y --no-install-recommends nodejs npm tmux

# overmind
RUN  wget -q https://github.com/DarthSim/overmind/releases/download/v2.0.0/overmind-v2.0.0-linux-amd64.gz \
        && gunzip overmind-v2.0.0-linux-amd64.gz \
        && chmod +x overmind-v2.0.0-linux-amd64 \
        && mv overmind-v2.0.0-linux-amd64 /usr/local/bin/overmind

RUN gem install bundler -v 2.2.20

WORKDIR /app

COPY Gemfile Gemfile.lock ./

RUN bundle check || bundle install

COPY package.json ./

RUN npm install

COPY . ./
ENTRYPOINT ["./entrypoints/docker-entrypoint.sh"]
CMD [ "overmind", "start" ]

EXPOSE 3000
