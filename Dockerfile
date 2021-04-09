ARG RUBY_VERSION

FROM ruby:$RUBY_VERSION-alpine

ARG BUNDLER_VERSION
ARG RAILS_VERSION

LABEL maintainer="thibaut.poullain@ydrazil.fr"
LABEL version="0.0.1"

RUN apk update && \
  apk upgrade && \
  apk add --update --no-cache \
      binutils-gold \
      build-base \
      curl \
      file \
      g++ \
      gcc \
      git \
      less \
      libstdc++ \
      libffi-dev \
      libc-dev \
      linux-headers \
      libxml2-dev \
      libxslt-dev \
      libgcrypt-dev \
      make \
      netcat-openbsd \
      nodejs \
      openssl \
      pkgconfig \
      postgresql-dev \
      tzdata \
      yarn

ENV LANG=C.UTF-8
ENV GEM_HOME=/bundle
ENV BUNDLE_JOBS=4
ENV BUNDLE_RETRY=3
ENV BUNDLE_PATH $GEM_HOME
ENV BUNDLE_APP_CONFIG=$BUNDLE_PATH
ENV BUNDLE_BIN=$BUNDLE_PATH/bin
ENV PATH /app/bin:$BUNDLE_BIN:$PATH
ENV RAILS_ROOT /app/

 RUN gem update --system && \
  gem install bundler -v $BUNDLER_VERSION

RUN mkdir -p $RAILS_ROOT

WORKDIR $RAILS_ROOT

COPY Gemfile Gemfile.lock ./

RUN bundle config build.nokogiri --use-system-libraries

RUN bundle check || bundle install --jobs=$BUNDLE_JOBS

COPY package.json yarn.lock ./

RUN yarn install --check-files

COPY . $RAILS_ROOT

CMD ["bundle", "exec", "rails", "server", "-b", "0.0.0.0"]






