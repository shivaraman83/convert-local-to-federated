#!/bin/python3
#
# This script takes a file with a list of repos and types (generated via get-list-of-artifactory-repos.py )
# and iterates through and matches the repo name against a hard coded list of repos to ignore, 
# which is defined below.   If there is no match with the exclude list,  the repo will be moved into
#the target project. 


# Per Siva, order is important, so we will do this 3 times in 3 separate passes with Virtual,  Local and Remote


# BE SURE TO CHECK USER SETTINGS FOR REPO LIST, PROJECT AND EXCLUDE LIST TOWARD THE BOTTOM BEFORE RUNNING


import os
import time # Sleep

# For now, only the saas instance supports projects.  
#TOKEN = os.environ['ACCESS_TOKEN_saas']


def rename_repos (REPO_LIST, REPO_TYPE_TO_PROCESS, TARGET_PROJECT):   # Expecting a line like: web-virtual-workflow-temp-08-05-00 VIRTUAL https://artifactory.dev.mykronos.com/artifactory/web-virtual-workflow-temp-08-05-00
    
    # Stuff needed to build out curl command

    CURL_PUT    = "curl --location --request PUT \'"  #Trailing whitespaces are important 
    ARTIFACTORY_SERVER = "https://saas.jfrog.io"
    ENDPOINT    =  "/access/api/v1/projects/_/attach/repositories/"
    HEADER_ARG  = " --header "
    AUTH_ARG    = "Authorization: Bearer " 
    SUFFIX      = "?force=false' --header 'Authorization: Bearer "
    TOKEN       = "<ID Token>"
    #TOKEN (Taken from Shell env. above)
    QUOTE       = "\'"
    SLASH       = "/"

    print ("--->Debug - called with", REPO_LIST, REPO_TYPE_TO_PROCESS, TARGET_PROJECT )                                    # We only care about the first 2 fields name and type.
    with open(REPO_LIST) as repos_to_move:
        for repo_line in repos_to_move:
            entry = repo_line.split(" ",2)

            #Item 0 is the name, Item 1 is the type
            REPO_NAME = entry[0]
            REPO_TYPE = entry[1]
            
            # If the type matches the type we are currently processing, then check further
            # to see if it's on the exclude list, and if not,  then rename it.
            if (REPO_TYPE_TO_PROCESS == REPO_TYPE):
                print ("processing Repo ", REPO_NAME, "Type ", REPO_TYPE)
                if REPO_NAME in EXCLUDE_LIST:
                    print("------------->Skipping Excluded Repo: ", REPO_NAME, " Type: ", REPO_TYPE)
                else:
                    print("--->Renaming ",REPO_NAME," Type: ",REPO_TYPE, " to ", TARGET_PROJECT)
                    curl --location --request PUT 'https://server.jfrog.io/access/api/v1/projects/_/attach/repositories/<repo-name>/<project-key>?force=false' --header 'Authorization: Bearer <token>'
                    api_command = CURL_PUT + ARTIFACTORY_SERVER + ENDPOINT + REPO_NAME + SLASH + TARGET_PROJECT + SUFFIX + TOKEN + QUOTE
                    print("Executing api command: ",api_command)
                    command_exe = os.system(api_command)
                    time.sleep(.5)




# Script begins here...


# ---------------------------->To be set by user prior to run. <--------------------
TARGET_PROJECT = 'wfc'   #  Note:  This needs to be the project Key, not the project name. 
REPO_LIST = 'artifactory-repo-list.txt'


#------------------>  Update the exclude list for each instance <-------------------
#Exclude list should be any repos which exist in the "repo conflicts" page from confluence,
#since we want to be sure we do not re-assign previously existing top level repos. 
# Used for Dimensions:   EXCLUDE_LIST = ["example-local","ext-release-local"]


# Sample exclude list  (TO be sure we don't grab other people's repos because they have a name conflict with this instance)
EXCLUDE_LIST = ["ext-release-virtual","alawler-junk"]



#------------------ No user servicable parts below----------------------------

REPO_TYPES = ["LOCAL","REMOTE","VIRTUAL"]


for REPO_TYPE_TO_PROCESS in (REPO_TYPES):
    print ("Processing repo type ", REPO_TYPE_TO_PROCESS)
    rename_repos(REPO_LIST, REPO_TYPE_TO_PROCESS, TARGET_PROJECT)

