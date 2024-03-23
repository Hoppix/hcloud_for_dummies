#!/usr/bin/env bash

set -o errexit
set -o pipefail
set -o nounset

if [[ "${TRACE-0}" == "1" ]]; then
    set -o xtrace
fi

if [[ "${1-}" =~ ^-*h(elp)?$ ]]; then
    echo 'Usage: ./deploy_terraform.sh <action>
'
    exit
fi

cd "$(dirname "$0")"

main() {

  source ../.env
  action=$1
  log "calling deploy_terraform.sh with action: $action"

  export TF_VAR_hcloud_token=$HCLOUD_TOKEN

  log "token is $TF_VAR_hcloud_token"

  pushd ../terraform/
  terraform $action
  popd
}

log() {
  dt=$(date)
  echo "LOG $dt $1"
}

main "$@"

