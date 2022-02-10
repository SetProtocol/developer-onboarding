#!/usr/bin/env sh

set -e

full_db_setup() {
  rake db:create
  rake db:migrate
}

if [ "$1" = 'web' ]; then
  /wait
  full_db_setup
  exec foreman s web
fi

if [ "$1" = 'worker' ]; then
  /wait
  full_db_setup
  exec foreman s worker
fi

if [ "$1" = 'test' ]; then
  shift
  export RAILS_ENV=test
  export INFURA_PROJECT_ID=
  /wait
  rake db:migrate
  exec rspec "$@"
fi

if [ "$1" = 'lint' ]; then
  exec app bundle exec rubocop -a
fi

if [ "$1" = 'bump-models' ]; then
  # Since the container filesystem may be out-of-date (see: http://docs.docker.oeynet.com/docker-for-mac/osxfs-caching/#cached), 
  # force an update of the git index.
  git status

  # Update private gem for new migrations and model logic
  exec rake vendorise:gem[git@github.com:SetProtocol/set-models.git]
fi


exec "$@"
