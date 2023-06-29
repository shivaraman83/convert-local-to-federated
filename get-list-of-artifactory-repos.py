#!bin/python3
# Borrowed from Jfrog online docs: https://jfrog.com/knowledge-base/artifactory-how-to-get-the-list-of-admin-users-in-artifactory/

# This script generates lists of both local  and admin artifactory users.  
# To run,  update the ARTIFACTORY_SERVER and Access String values shown below and run with Python 3.
# It can take a while to run against a large artifactory with lots of users.


import json
import os



# User needs to change these values as appropriate prior to running. (Preserve the leading space)
ARTIFACTORY_SERVER = ' https://server.jfrog.io'   # uses v7 endpoint for some reason




ACCESS_STRING = '\"uname:<REMOVED>"' # Remember to escape any special chars (I.e. $ ) for linux, but NOT for windows.
#

#--------------------- Do not change anything below this line ------------------

ENDPOINT = '/artifactory/api/repositories'  # V7 endpoint
#ENDPOINT = '/api/repositories'              # 

ARTIFACTORY_URL = ARTIFACTORY_SERVER + ENDPOINT
COMMAND = 'curl -k -s -u  '    # -k required for artifactory, which uses self signed certs.

print("Processing... (This could take a while.)")

command_s = COMMAND + ACCESS_STRING + ARTIFACTORY_SERVER + ENDPOINT

command_e = " > ./repolist.json"

request = command_s + command_e

command_exe = os.system(request)

#reads the intermediate json file containing the list of repos

with open('./repolist.json', 'r') as fcc_file:

   api_data = json.load(fcc_file)

   values = []

   #creates a list named 'values' which contains the user names

   for i in api_data:
       #--> Use this to print out a list of all repos:  print (i["key"], i["type"], i["url"])
       #print (i["key"], i["type"], i["url"])
       print (i["key"], i["type"])
       
