# Convert Local repos to federated repos

Below steps needs to be followed to convert all your local repositories to federated repositories. Use case for this - if you are setting up a Cold/Warm DR

## Pre-requisites
1. instanceurl - your active instance url
2. dr-instanceurl - cold/warm instance url 
3. Federated repository binding between your instance and dr-instance
4. Shell script requires jq to be installed 

## Steps 
1. ./convertLocalToFed.sh https://instanceurl.jfrog.io admin-user-id admin-id-token
2. ./fed_create_yaml.sh https://instanceurl.jfrog.io https://dr-instanceurl.jfrog.io admin-user-id admin-id-Token
3. ./fed_repo_member_sync.sh https://instanceurl.jfrog.io admin-user-id admin-id-token