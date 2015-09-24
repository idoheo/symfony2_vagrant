#!/bin/bash
if [ $# -ne 1 ]; then
  echo "Expected exactly one parameter: ppa repository name";
  exit 1;
fi;

REPOSITORY_NAME=$1;
REPOSITORY_ADDED="egrep  \"^[^\#]\" /etc/apt/sources.list /etc/apt/sources.list.d/* -h 2>/dev/null| egrep \"http://ppa.launchpad.net/$REPOSITORY_NAME/ubuntu\" | wc -l";
REPOSITORY_ADD="sudo add-apt-repository --yes ppa:$REPOSITORY_NAME";
REPOSITORY_REMOVE="sudo add-apt-repository --remove --yes ppa:$REPOSITORY_NAME";
UPDATE_APT="sudo apt-get update -q -qq";
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
MANAGER_PACKAGE="python-software-properties";

sudo apt-get install -y -qq $MANAGER_PACKAGE;

echo "";
echo "--- MANAGING REPOSITORY --";
echo "--- REPOSITORY: $REPOSITORY_NAME";

PREFORM_UPDATE_APT=0;

while [[ $(eval $REPOSITORY_ADDED) -gt 1 ]]
do
	echo "--- Removing duplicate of $REPOSITORY_NAME";
 	eval $REPOSITORY_REMOVE;
        PREFORM_UPDATE_APT=1;
done;

if [[ $(eval $REPOSITORY_ADDED) -lt 1 ]]; then
	echo "--- Adding $REPOSITORY_NAME repository";
	eval $REPOSITORY_ADD;
        if [[ $? -eq 0 ]]; then
           PREFORM_UPDATE_APT=1;
	fi;
fi;

if [[ $PREFORM_UPDATE_APT -gt 0 ]]; then
	echo "--- Updateing APT";
	eval $UPDATE_APT;
fi;

if [[ $(eval $REPOSITORY_ADDED) -gt 0 ]]; then
	echo "--- Repository $REPOSITORY_NAME is present";
	exit 0;
else
	echo "-!- Repository $REPOSITORY_NAME is missing";
	exit 1;
fi;
