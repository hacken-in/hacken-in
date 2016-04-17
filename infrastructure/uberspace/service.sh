#!/bin/bash
set -e

app_name=`basename "$0"`
path=`dirname $(readlink $0)`

runner="${path}/runner.rb"
source "${HOME}/${app_name}.secrets"
export APP_PATH=`dirname $(dirname ${path})`

exec $runner
