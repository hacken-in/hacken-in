#!/bin/bash
set -e

app_name=`basename "$0"`
path=`dirname $(readlink $0)`

source "${HOME}/${app_name}.secrets"
export APP_PATH=`dirname $(dirname ${path})`
export APP_NAME=$app_name
cd $APP_PATH

exec bundle exec puma -C config/puma.rb
