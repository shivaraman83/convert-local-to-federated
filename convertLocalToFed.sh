#! /bin/bash

# JFrog hereby grants you a non-exclusive, non-transferable, non-distributable right
# to use this  code   solely in connection with your use of a JFrog product or service.
# This  code is provided 'as-is' and without any warranties or conditions, either
# express or implied including, without limitation, any warranties or conditions of
# title, non-infringement, merchantability or fitness for a particular cause.
# Nothing herein shall convey to you any right or title in the code, other than
# for the limited use right set forth herein. For the purposes hereof "you" shall
# mean you as an individual as well as the organization on behalf of which you
# are using the software and the JFrog product or service.

### Exit the script on any failures
set -eo pipefail
set -e
set -u

### Get Arguments
SOURCE_JPD_URL="${1:?please enter JPD URL. ex - https://ramkannan.jfrog.io}"
USER_NAME="${2:?please provide the username in JPD . ex - admin}"
JPD_AUTH_TOKEN="${3:?please provide the identity token}"

### define variables
reposfile="repos_list_local.txt"

### Run the curl API
rm -rf *.json
curl -X GET -H 'Content-Type: application/json' -u "${USER_NAME}":"${JPD_AUTH_TOKEN}" "${SOURCE_JPD_URL}/artifactory/api/repositories?type=local" -s | jq -rc '.[] | .key' > $reposfile

while IFS= read -r repo; do
    echo -e "\nPerforming conversion of Local to Federated repo for $repo"
    curl -X POST -H 'Content-Type: application/json' -u "${USER_NAME}":"${JPD_AUTH_TOKEN}" "$SOURCE_JPD_URL/artifactory/api/federation/migrate/$repo"
    echo -e ""
done < $reposfile

### sample cmd to run - ./convertLocalToFed.sh https://instanceurl.jfrog.io admin ****