#!/usr/bin/env sh

set -ex

action=$1
option=$2

if [[ "${action}" == "push" ]]; then
  if [[ "${option}" == "test" ]]; then
    git push staging master --no-verify
    git push staging-mainnet master --no-verify

    read -p "Do you wish to also perform a DB migrate to staging/staging-mainnet? (y/n) " yn
    case $yn in
        [Yy]* ) heroku run rake db:migrate -a set-core-staging; heroku run rake db:migrate -a set-core-staging-mainnet; break;;
        [Nn]* ) echo "Skipping.";;
        * ) echo "Skipping.";;
    esac
  elif [[ "${option}" == "production" ]]; then
    git push production master --no-verify

    read -p "Do you wish to also perform a DB migrate to production? (y/n) " yn
    case $yn in
        [Yy]* ) heroku run rake db:migrate -a set-core-production; break;;
        [Nn]* ) echo "Skipping.";;
        * ) echo "Skipping.";;
    esac
  fi
fi
