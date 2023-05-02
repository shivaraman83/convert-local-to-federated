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
## define variables
source="${1:?source-serverId ex - source-server}"
target="${2:?target-serverId . ex - target-server}"
cd replication

reposfile="repositories.list"
rm -rf repositories.list
rm -rf *.json

jf config use ${source}

### Run the curl API
jf rt curl api/repositories?type=local | grep "key" > repositories.list
##curl -s -u "${USER_NAME}":"${JPD_AUTH_TOKEN}" "${SOURCE_JPD_URL}/artifactory/api/repositories?type=local" | grep "key" > repositories.list

cat repositories.list |  while read line
do
    REPO=$(echo $line | cut -d ':' -f 2)
    REPO_FILENAME=$(echo ${REPO%??} | cut -c 2-) #Get a good looking filename
    ##jf rt curl api/replications/$REPO_FILENAME -s | grep message | xargs
    data=$(jf rt curl api/replications/$REPO_FILENAME -s | grep message | xargs)
    if [[ $data == *"message"*  ]];then
     echo $data
     #Variable setup
     #Get the repository key, remove "key": from the JSON
     #Insert the static default parameters
     echo '{ "enabled": "true","cronExp":"0 0 12 * * ?",' > $REPO_FILENAME-template.json
     #Insert the repository Key
     echo '"repoKey": '$REPO >> $REPO_FILENAME-template.json
     #Insert the remaining parameters, note we're replicating to the same repository name
     echo '"serverId": "'$target'", "targetRepoKey": '$REPO' "enableEventReplication":"true" }' >> $REPO_FILENAME-template.json
     ## Create delete replication script proactively
     echo  "jf rt replication-delete $REPO_FILENAME --quiet" >> delete-replication.txt
   else
       echo "replication configured"
       echo "$REPO_FILENAME" >> replication-configured-repos.txt
   fi
done

ls *.json  | while read line
do
     echo "jf rt replication-create $line"
     jf rt replication-create $line
done


### sample cmd to run - ./set-replication.sh source-server target-server