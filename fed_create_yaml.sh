#! /bin/bash

SOURCE_JPD_URL="${1:?please enter JPD URL. ex - https://ramkannans-sbx.dev.gcp.devopsacc.team}"
TARGET_JPD_URL="${2:?please enter JPD URL. ex - https://ramkannans-apac-sbx.dev.gcp.devopsacc.team}"
USER_NAME="${3:?please provide the username in JPD . ex - admin}"  ### common credentials across 3 JPD's
USER_TOKEN="${4:?please provide the user pwd or token or API Key . ex - password}"  ### common credentials across 3 JPD's

./getRepoList.sh "$SOURCE_JPD_URL" federated "$USER_NAME" "$USER_TOKEN"

FILE_NAME="fed_repo_list.yaml"

rm -rf $FILE_NAME

echo "federatedRepositories:" > $FILE_NAME

while IFS= read -r reponame; do
    echo -e "  ${reponame}:" >> $FILE_NAME
    echo -e "    federatedMembers:" >> $FILE_NAME 
    echo -e "      - url: ${SOURCE_JPD_URL}/artifactory/${reponame}" >> $FILE_NAME
    echo -e "        enabled: true" >> $FILE_NAME
    echo -e "      - url: ${TARGET_JPD_URL}/artifactory/${reponame}" >> $FILE_NAME
    echo -e "        enabled: true" >> $FILE_NAME
done < repos_list_federated.txt 

### sample cmd to run - ./fed_create_yaml.sh https://instanceurl.jfrog.io https://dr-instanceurl.jfrog.io admin ****