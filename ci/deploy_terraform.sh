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
  log "Running with $0"

  local ACTION=$1

  pushd ~/.ssh
  local SSH_PUBLIC_KEY=$(setup_ssh)
  log "SSH Public key is: $SSH_PUBLIC_KEY"
  popd 

  export TF_VAR_hcloud_token=$HCLOUD_TOKEN
  export TF_VAR_service=$SERVICE
  export TF_VAR_ssh_user=$SERVICE
  export TF_VAR_ssh_public_key=$SSH_PUBLIC_KEY

  log "Running terraform with action: $ACTION"
  pushd ../terraform/
  terraform $ACTION
  popd
}

setup_ssh() {
  local SSH_FILE="hcloud_$SERVICE"

  if [ ! -f $SSH_FILE ]; then
    ssh-keygen -f $SSH_FILE -t rsa -b 4096 -N ''
  fi
  local PUBLIC_KEY=$(cat "$SSH_FILE.pub")
  echo $PUBLIC_KEY
}

log() {
  dt=$(date)
  echo "LOG $dt $1"
}

main "$@"

