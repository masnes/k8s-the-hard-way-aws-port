#!/bin/bash
script_dir="$(dirname "$(readlink -f "$0")")"
cd "$script_dir"

export TF_STATE="$script_dir/../tf/"
check_and_run_playbook() {
  ansible-playbook --inventory-file="$script_dir"/hosts "$@" --syntax-check
  ansible-playbook --inventory-file="$script_dir"/hosts "$@"
}
check_and_run_playbook "$@"
