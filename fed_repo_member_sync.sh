#!/bin/sh

### Exit the script on any failures
set -eo pipefail
set -e
set -u

### Get Arguments
SOURCE_JPD_URL="${1:?please enter JPD URL. ex - https://ramkannan.jfrog.io}"
USER_NAME="${2:?please provide the username in JPD . ex - admin}"
JPD_AUTH_TOKEN="${3:?please provide the user identity token}"

curl -X PATCH -H 'Content-Type: application/yaml' -u "${USER_NAME}":"${JPD_AUTH_TOKEN}" "${SOURCE_JPD_URL}/artifactory/api/system/configuration" -T fed_repo_list.yaml

##jf rt curl -XPATCH /api/system/configuration -T fed_repo_list.yaml
yq e fed_repo_list.yaml -o=j -I=0 |  jq -r '.[]|keys[]' |
while read -r repo_id; do
  echo "\nSync for REPO ID ==> $repo_id"
  #jf rt curl -XPOST /api/federation/configSync/$repo_id
  curl -X POST -H 'Content-Type: application/yaml' -u "${USER_NAME}":"${JPD_AUTH_TOKEN}" "${SOURCE_JPD_URL}/artifactory/api/federation/configSync/$repo_id"
done

### sample cmd to run - ./fed_create_yaml.sh https://instanceurl.jfrog.io admin ****