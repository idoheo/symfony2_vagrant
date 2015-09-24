#!/bin/bash

## Environment definition
ANSIBLE_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )";

## Commands definition
COMMAND_ADD_ANSIBLE="chmod u+x $ANSIBLE_DIR/../add_ppa_repository.sh && $ANSIBLE_DIR/../add_ppa_repository.sh ansible/ansible";
COMMAND_INSTALL_ANSIBLE="sudo apt-get -y --force-yes --no-install-recommends -q -qq install ansible python-apt aptitude"

## Execute ansible commands
eval $COMMAND_ADD_ANSIBLE && eval $COMMAND_INSTALL_ANSIBLE;
RESULT=$?;

## Return result
exit $RESULT;
