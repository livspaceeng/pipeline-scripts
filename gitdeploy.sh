#!/bin/bash

APP_NAME=$1
APPVERSION=2
ENV=$3

dev="https://${GIT_CI_USER}:${GIT_CI_TOKEN}@gitlab.com/livspaceengg/testdeploydebasis.git" 
beta="https://${BB_USER_ID}:${BB_USER_TOKEN}@bitbucket.org/livspaceeng/environment-jx-dev.giit"

rm -rf /tmp/env || echo "No cleanup required, /tmp/env doesnt exist"
mkdir /tmp/env && cd /tmp/env
if [ $ENV == "master" ]; then
  git clone "${beta}"  .
elif [ $ENV == "test" ]; then
  git clone "${dev}"  .
else
  exit 0
fi
git config --global user.name "${CI_BOT_USER}"
git config --global user.email "${CI_BOT_EMAIL}"
rm -rf output.yaml || echo "output.yaml doesnt exist"
python /tmp/scripts/req-edit.py test.yaml $APP_NAME $APPVERSION
cp output.yaml test.yaml
git add .
git commit -m "Upgrading version of $APP_NAME to $APPVERSION"
git push
