#!/usr/bin/env sh

set -e

rake() {
  bundle exec rake db:create
  bundle exec rake db:migrate
}

if [ "$1" = 'web' ]; then
  /wait
  rake
  foreman s web
fi

if [ "$1" = 'worker' ]; then
  /wait
  rake
  foreman s worker
fi

if [ "$1" = 'test' ]; then
  shift
  export RAILS_ENV=test
  export INFURA_PROJECT_ID=
  /wait
  rake db:migrate
  exec bundle exec rspec "$@"
fi

if [ "$1" = 'bump-models' ]; then
  # Update private gem for new migrations and model logic
  exec rake vendorise:gem[git@github.com:SetProtocol/set-models.git]
fi


exec "$@"
