# Convert Local repos to federated repos

Below steps needs to be followed to convert all your local repositories to federated repositories. Use case for this - if you are setting up a Cold/Warm DR of Jfrog artifactory for the first time

## Pre-requisites
1. instanceurl - your active instance url
2. dr-instanceurl - cold/warm instance url 
3. Federated repository binding between your instance and dr-instance
4. Shell script requires jq to be installed 
5. admin-user-id - admin account for your instance
6. admin-id-token - ID token of your admin user

## Assumptions
The steps below assume you are setting a new DR instance for the first time and all the repo names match your primary instance

## Steps 
1. Register the other JPD’s from your main instance - https://jfrog.com/help/r/jfrog-platform-administration-documentation/managing-platform-deployments
2. Create a federated repository binding between the JPD's through the UI -https://jfrog.com/help/r/jfrog-platform-administration-documentation/binding-tokens#BindingTokens-SettingupBindingTokens
### Run on both the instance and dr-instance
3. ```./convertLocalToFed.sh https://instanceurl.jfrog.io admin-user-id admin-id-token```
### Run only on the main instance 
4. ```./fed_create_yaml.sh https://instanceurl.jfrog.io https://dr-instanceurl.jfrog.io admin-user-id admin-id-Token```
5. Now sync the members ```./fed_repo_member_sync.sh https://instanceurl.jfrog.io admin-user-id admin-id-token```

python3 repoDiff.py --source-artifactory pro --target-artifactory proservices --source-repo fsg-th-docker-snapshots --target-repo fsg-th-docker-snapshots
