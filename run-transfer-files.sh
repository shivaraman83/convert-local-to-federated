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


cd transfer

reposfile="repositories.list"
rm -rf repositories.list


jf config use ${source}

### Run the curl API
jf rt curl api/repositories?type=${TYPE} -s | jq -rc '.[] | .key' > repositories.list
##curl -s -u "${USER_NAME}":"${JPD_AUTH_TOKEN}" "${SOURCE_JPD_URL}/artifactory/api/repositories?type=local" | grep "key" > repositories.list

cat repositories.list |  while read line
do
    REPO=$(echo $line | cut -d ':' -f 2)
    echo "Running     jf rt transfer-files $source $target --include-repos=$REPO"
    jf rt transfer-files $source $target --include-repos=$REPO
done

### sample cmd to run - ./run-transfer-files.sh source-server target-server