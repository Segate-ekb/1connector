#!/bin/bash

set -e

temp=`cat packagedef | grep ".Версия(" | sed 's|[^"]*"||' | sed -r 's/".+//'`
version=${temp##*|}

if [ "$TRAVIS_SECURE_ENV_VARS" == "true" ]; then
  sonar-scanner \
      -Dsonar.host.url=$SONAR_HOST \
      -Dsonar.login=$SONAR_TOKEN \
      -Dsonar.projectVersion=$version\
      -Dsonar.scanner.skip=false
fi