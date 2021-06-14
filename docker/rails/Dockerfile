# syntax=docker/dockerfile:1.2
# see: https://github.com/moby/buildkit/blob/master/frontend/dockerfile/docs/syntax.md
ARG RUBY_VERSION=2.5.9
ARG ALPINE_VERSION=3.13
ARG HAS_GEMSPEC
ARG HAS_VENDOR

FROM ruby:${RUBY_VERSION}-alpine${ALPINE_VERSION} AS base

ARG APP_DIR=/opt/set-labs/app
WORKDIR $APP_DIR

ENV BUNDLER_VERSION=1.17.3 \
    FOREMAN_VERSION=0.87.2 \
    DOCKER_COMPOSE_WAIT_VERSION=2.7.3

COPY docker-entrypoint.sh /usr/local/bin/

ADD https://github.com/ufoscout/docker-compose-wait/releases/download/$DOCKER_COMPOSE_WAIT_VERSION/wait /wait
RUN chmod +x /wait

RUN --mount=type=cache,target=/var/cache/apk ln -vs /var/cache/apk /etc/apk/cache && \
        apk add --update \
            build-base \
            gcc \
            git \
            git-subtree \
            openssh \
            musl-dev \
            nodejs \
            postgresql-dev \
            libpq

RUN gem install bundler:$BUNDLER_VERSION foreman:$FOREMAN_VERSION

ENTRYPOINT ["docker-entrypoint.sh"]

FROM base AS has-vendor-true
# Docker treats files and directory sources differently. Specifically, the directory structures are not preserved when
# multiple source paths are specified, so sometimes explicit copies like this are necessary.
COPY vendor ./vendor

FROM base AS has-vendor-false
# noop

FROM has-vendor-${HAS_VENDOR} AS gemspec-true
COPY Gemfile Gemfile.lock set_models.gemspec ./

FROM has-vendor-${HAS_VENDOR} AS gemspec-false
COPY Gemfile Gemfile.lock ./

FROM gemspec-${HAS_GEMSPEC} AS bundle
ENV BUNDLE_PATH=/bundler
RUN --mount=type=cache,target=/bundler bundle install

FROM bundle as web
CMD ["web"]

FROM bundle as worker
CMD ["worker"]