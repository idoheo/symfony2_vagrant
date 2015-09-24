#!/bin/bash

PROVISION_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

echo "--- Preforming APT maintainance";
sudo apt-get autoremove -y -q -qq 2>/dev/null;
sudo apt-get update -y -q -qq 2>/dev/null;
echo "--- APT maintainance done";

ANSIBLE_SCRIPT=$PROVISION_DIR/ansible/ansible.sh
chmod u+x $ANSIBLE_SCRIPT
$ANSIBLE_SCRIPT playbook-always
