#!/bin/bash
if [ $# -ne 1 ]; then
  echo "Expected exactly one parameter: playbook name";
  exit 1;
fi;

PLAYBOOK_NAME=$1;
PLAYBOOK_FILE="$PLAYBOOK_NAME.yml"
PLAYBOOK_DIST_FILE="dist/$PLAYBOOK_FILE"

PLAYBOOK_COMMON_VARS_FILE="default-playbook-vars.yml";
PLAYBOOK_COMMON_VARS_DIST_FILE="dist/$PLAYBOOK_COMMON_VARS_FILE";

PLAYBOOK_PLAYBOOK_VARS_FILE="$PLAYBOOK_NAME-vars.yml";
PLAYBOOK_PLAYBOOK_VARS_DIST_FILE="dist/$PLAYBOOK_PLAYBOOK_VARS_FILE";

## Environment definition
ANSIBLE_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )";
export PYTHONUNBUFFERED=1;
export ANSIBLE_FORCE_COLOR=1;

## Temproray hosts file setup
TEMP_HOSTS_FILE=$(tempfile)
cp $ANSIBLE_DIR/hosts $TEMP_HOSTS_FILE
chmod -x $TEMP_HOSTS_FILE

## Commands definition
COMMAND_INSTALL_ANSIBLE="$ANSIBLE_DIR/install_ansible.sh"
COMMAND_RUN_ANSIBLE="ansible-playbook -i $TEMP_HOSTS_FILE $ANSIBLE_DIR/$PLAYBOOK_FILE";

RESULT=0;

## Prepare playbook
if [ ! -f "$ANSIBLE_DIR/$PLAYBOOK_FILE" ]; then
    if [ ! -f "$ANSIBLE_DIR/$PLAYBOOK_DIST_FILE" ]; then
        echo "Playbook missing"
	RESULT=$[$RESULT +1]
    else
      echo "Copying playbook file from it's distribution version"
      cp $ANSIBLE_DIR/$PLAYBOOK_DIST_FILE $ANSIBLE_DIR/$PLAYBOOK_FILE
    fi
fi

## Prepare common variables
if [ ! -f "$ANSIBLE_DIR/$PLAYBOOK_COMMON_VARS_FILE" ]; then
    if [ ! -f "$ANSIBLE_DIR/$PLAYBOOK_COMMON_VARS_DIST_FILE" ]; then
        echo "Common variables file missing"
	RESULT=$[$RESULT +2]
    else
      echo "Copying common variables file it's distribution version"
      cp $ANSIBLE_DIR/$PLAYBOOK_COMMON_VARS_DIST_FILE $ANSIBLE_DIR/$PLAYBOOK_COMMON_VARS_FILE
    fi
fi

## Prepare playbook variables
if [ -f "$ANSIBLE_DIR/$PLAYBOOK_PLAYBOOK_VARS_DIST_FILE" ]; then
    if [ ! -f "$ANSIBLE_DIR/$PLAYBOOK_PLAYBOOK_VARS_FILE" ]; then
      echo "Copying playbook variables file from it's distribution version"
      cp $ANSIBLE_DIR/$PLAYBOOK_PLAYBOOK_VARS_DIST_FILE $ANSIBLE_DIR/$PLAYBOOK_PLAYBOOK_VARS_FILE
    fi
fi

if [ "$RESULT" -gt 0 ]; then
  echo "Abandoning Ansible playbook run..."
  exit $RESULT;
fi;

## Execute ansible commands
chmod u+x $COMMAND_INSTALL_ANSIBLE && $COMMAND_INSTALL_ANSIBLE && $COMMAND_RUN_ANSIBLE;
RESULT=$?;

## CLEANUP
rm $TEMP_HOSTS_FILE

## Return result
exit $RESULT;
