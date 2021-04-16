FROM ruby:2.7.2-alpine as Builder
LABEL maintainer="thibaut.poullain@ydrazil.fr"

RUN apk add --no-cache \
      build-base \
      postgresql-dev \
      sqlite-dev \
      git \
      nodejs \
      yarn \
      tzdata \
      file

WORKDIR /app

COPY package.json yarn.lock /app/
RUN yarn install --frozen-lockfile

COPY Gemfile* /app/
RUN bundle config --local frozen 1 && \
    bundle install -j4 --retry 3

ONBUILD COPY Gemfile* /app/
ONBUILD RUN bundle config --local without 'development test' && \
            bundle install -j4 --retry 3 && \
            bundle clean --force && \
            rm -rf /usr/local/bundle/cache/*.gem && \
            find /usr/local/bundle/gems/ -name "*.c" -delete && \
            find /usr/local/bundle/gems/ -name "*.o" -delete

ONBUILD COPY . /app

# Compile assets with Webpacker or Sprockets
#
# Notes:
#   1. Executing "assets:precompile" runs "yarn:install" prior
#   2. Executing "assets:precompile" runs "webpacker:compile", too
#   3. For an app using encrypted credentials, Rails raises a `MissingKeyError`
#      if the master key is missing. Because on CI there is no master key,
#      we hide the credentials while compiling assets (by renaming them before and after)
#
ONBUILD RUN mv config/credentials.yml.enc config/credentials.yml.enc.bak 2>/dev/null || true
ONBUILD RUN mv config/credentials config/credentials.bak 2>/dev/null || true
ONBUILD RUN --mount=type=secret,id=npmrc,dst=/root/.npmrc \
            --mount=type=secret,id=yarnrc,dst=/root/.yarnrc.yml \
            RAILS_ENV=production \
            SECRET_KEY_BASE=dummy \
            RAILS_MASTER_KEY=dummy \
            bundle exec rails assets:precompile
ONBUILD RUN mv config/credentials.yml.enc.bak config/credentials.yml.enc 2>/dev/null || true
ONBUILD RUN mv config/credentials.bak config/credentials 2>/dev/null || true

ONBUILD RUN rm -rf node_modules tmp/cache vendor/bundle test spec app/javascript app/packs
