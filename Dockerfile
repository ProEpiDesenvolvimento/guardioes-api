FROM ruby:2.5.3-alpine as builder

RUN apk add --update --no-cache \
  build-base \
  libxml2-dev \
  libxslt-dev \
  curl-dev \
  git \
  postgresql-dev \
  postgresql-client \
  yaml-dev \
  zlib-dev \
  nodejs \
  yarn \
  tzdata

COPY Gemfile Gemfile.lock ./
RUN bundle install

FROM ruby:2.5.3-alpine

RUN apk add --update --no-cache \
  tzdata \
  postgresql-client \
  nodejs \
  bash

COPY --from=builder /usr/local/bundle/ /usr/local/bundle/

ENV TZ=America/Sao_Paulo
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone

RUN mkdir /myapp
WORKDIR /myapp

COPY . .

# Add a script to be executed every time the container starts.
COPY entrypoint.sh /usr/bin/
RUN chmod +x /usr/bin/entrypoint.sh
ENTRYPOINT ["entrypoint.sh"]
EXPOSE 3001

# Start the main process.
CMD ["rails", "server", "-b", "0.0.0.0"]
