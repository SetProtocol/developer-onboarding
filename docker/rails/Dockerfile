FROM ruby:2.5.9-alpine3.13

ARG APP_DIR=/app

COPY docker-entrypoint.sh /usr/local/bin/

# see: https://github.com/ufoscout/docker-compose-wait
ADD https://github.com/ufoscout/docker-compose-wait/releases/download/2.7.3/wait /wait
RUN chmod +x /wait

WORKDIR $APP_DIR

RUN gem install bundler:1.17.3 foreman:0.87.2

COPY Gemfile Gemfile.lock ./

# This step is unfortunate because it should be groupeable with the prior COPY. But it is ncessary because Docker treats
# files and directory sources differently. Specifically, the directory structures are not preserved when multiple source
# paths are specified.
COPY vendor ./vendor


RUN apk add --no-cache --update \
        build-base \
        gcc \
        git \
        openssh \
        git-subtree \
        musl-dev \
        nodejs \
        tzdata \
        postgresql-dev && \
    bundle install --no-cache && \
    apk add --no-cache --update libpq

ENTRYPOINT ["docker-entrypoint.sh"]
CMD ["web"]
