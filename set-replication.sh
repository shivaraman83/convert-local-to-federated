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
SOURCE_JPD_URL="${1:?please enter JPD URL. ex - https://instanceurl.jfrog.io}"
USER_NAME="${2:?please provide the username in JPD . ex - admin}"
JPD_AUTH_TOKEN="${3:?please provide the identity token}"

### define variables

cd replication

reposfile="repositories.list"
rm -rf repositories.list
rm -rf *.json

### Run the curl API
curl -s -u "${USER_NAME}":"${JPD_AUTH_TOKEN}" "${SOURCE_JPD_URL}/artifactory/api/repositories?type=local" | grep "key" > repositories.list

cat repositories.list |  while read line
do
   #Variable setup
   #Get the repository key, remove "key": from the JSON
   REPO=$(echo $line | cut -d ':' -f 2)
   REPO_FILENAME=$(echo ${REPO%??} | cut -c 2-) #Get a good looking filename
   #Insert the static default parameters
   echo '{ "enabled": "true","cronExp":"0 0 12 * * ?",' > $REPO_FILENAME-template.json
   #Insert the repository Key
   echo '"repoKey": '$REPO >> $REPO_FILENAME-template.json
  #Insert the remaining parameters, note we're replicating to the same repository name
   echo '"serverId": "target-server", "targetRepoKey": '$REPO' "enableEventReplication":"true" }' >> $REPO_FILENAME-template.json
done

jf config use source-server
ls *.json  | while read line
do
     echo "jf rt replication-create $line"
     jf rt replication-create $line
done


### sample cmd to run - ./convertLocalToFed.sh https://instanceurl.jfrog.io admin ****