#!/usr/bin/env sh

# Usage:
### Push HEAD to staging and staging-mainnet
# developer-onboarding/release-helper.sh push-test
#
#
### Push HEAD to all 3 stages
# developer-onboarding/release-helper.sh push-production
#
#
### Push the current branch, instead of HEAD, to staging and staging-mainnet
# developer-onboarding/release-helper.sh push-branch

set -ex

action=$1

repo_name=$(basename `git rev-parse --show-toplevel`)

if [[ "${action}" == "push-test" ]]; then
  git push staging master --no-verify
  git push staging-mainnet master --no-verify

  read -p "Do you wish to also perform a DB migrate to staging/staging-mainnet? (y/n) " yn
  case $yn in
      [Yy]* ) heroku run rake db:migrate -a $repo_name-staging; heroku run rake db:migrate -a $repo_name-staging-mainnet; break;;
      [Nn]* ) echo "Skipping.";;
      * ) echo "Skipping.";;
  esac
elif [[ "${option}" == "push-branch" ]]; then
  branch=$(git rev-parse --abbrev-ref HEAD)
  echo "Pushing branch ${branch}:master to staging and staging-mainnet."

  git push staging $branch:master
  git push staging-mainnet $branch:master

  read -p "Do you wish to also perform a DB migrate to staging/staging-mainnet? (y/n) " yn
  case $yn in
      [Yy]* ) heroku run rake db:migrate -a $repo_name-staging; heroku run rake db:migrate -a $repo_name-staging-mainnet; break;;
      [Nn]* ) echo "Skipping.";;
      * ) echo "Skipping.";;
  esac
elif [[ "${option}" == "push-production" ]]; then
  git push production master --no-verify

  read -p "Do you wish to also perform a DB migrate to production? (y/n) " yn
  case $yn in
      [Yy]* ) heroku run rake db:migrate -a $repo_name-production; break;;
      [Nn]* ) echo "Skipping.";;
      * ) echo "Skipping.";;
  esac
fi
