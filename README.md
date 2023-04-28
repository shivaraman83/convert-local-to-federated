# Convert Local repos to federated repos

Below steps needs to be followed to convert all your local repositories to federated repositories. Use case for this - if you are setting up a Cold/Warm DR

## Pre-requisites
1. instanceurl - your active instance url
2. dr-instanceurl - cold/warm instance url 
3. Federated repository binding between your instance and dr-instance
4. Shell script requires jq to be installed 
5. admin-user-id - admin account for your instance
6. admin-id-token - ID token of your admin user

## Steps 
### Run on both the instance and dr-instance
1. ./convertLocalToFed.sh https://instanceurl.jfrog.io admin-user-id admin-id-toke
### Run only on the main instance 
2. ./fed_create_yaml.sh https://instanceurl.jfrog.io https://dr-instanceurl.jfrog.io admin-user-id admin-id-Token
3. Register the other JPD’s - https://jfrog.com/help/r/jfrog-platform-administration-documentation/managing-platform-deployments
4. Create a federated repository binding between the JPD's through the UI -https://jfrog.com/help/r/jfrog-platform-administration-documentation/binding-tokens#BindingTokens-SettingupBindingTokens
5. Now sync the members ./fed_repo_member_sync.sh https://instanceurl.jfrog.io admin-user-id admin-id-token