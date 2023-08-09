

#SOURCE_JPD_URL="${1:?please enter JPD URL. ex - https://proservices.jfrog.io}"
#JPD_AUTH_TOKEN="${2:?ID token . ex - Identity token}"
source="${1:?source-serverId ex - source-server}"

cd storage

jf config use ${source}
#rm repositories*.list

##cat users-test.list
#cat repositories-unique.list |  while read line
#do
jf rt curl api/storageinfo | jq '[.repositoriesSummaryList[] | {repoKey: .repoKey, repoType: .repoType,  itemsCount: .itemsCount, usedSpace: .usedSpace}] ' > storageinfo.json


cat  storageinfo.json  | jq -r '.[] | select(.usedSpace == "0 bytes") | select(.repoType == "LOCAL")  | .repoKey' > ${source}-emptyRepositories.list
##cat  storageinfo.json  | jq -r '.[] | select(.usedSpace == "0 bytes") | select(.repoType == "LOCAL")  | .repoKey ' > emptyRepositories.list
cat  storageinfo.json  | jq -r '.[] | select(.itemsCount != 0) | select(.repoType == "LOCAL") | {repoKey: .repoKey,  usedSpace: .usedSpace} ' > ${source}-nonEmptyRepositories.json
cat  storageinfo.json  | jq -r '.[] | select(.itemsCount != 0) | select(.repoType == "LOCAL")  | .repoKey, .usedSpace' > ${source}-non-emptyRepositories.list

 ##curl -H"Authorization: Bearer $JPD_AUTH_TOKEN" -H "Content-Type: application/json" $SOURCE_JPD_URL/artifactory/api/storageinfo | jq '[.repositoriesSummaryList[] | {repoKey: .repoKey, itemsCount: .itemsCount, usedSpace: .usedSpace}] ' > storageinfo.json

#done









