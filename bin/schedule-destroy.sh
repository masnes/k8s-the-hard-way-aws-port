#!/bin/bash
set -e

if ! which at ; then
  echo >&2 "Error. 'at' package is not installed. Cannot auto-schedule teardown."
  exit 1
fi

script_dir="$(dirname "$(readlink -f "$0")")"

job_contains_destroy_canary() {
  job="$1"
  at -c "$job" | grep -q 'DESTROY_CANARY_K8S_PLAYGROUND'
}

while read -r "job" ; do
  if job_contains_destroy_canary "$job" ; then
    atrm "$job"
    echo "Cancelled previously scheduled teardown."
  fi
done <<<"$(atq | awk '{print $1}')"

ADDITIONAL_TIME="30 minutes"
if [[ -n "$1" ]]; then
  ADDITIONAL_TIME="$1"
fi
echo "Will teardown setup in $ADDITIONAL_TIME"
(
set -x
at "now + $ADDITIONAL_TIME" <<EOF
"$script_dir/../tf/apply.sh" destroy
# DESTROY_CANARY_K8S_PLAYGROUND
EOF
)

echo "To view: atq"
echo "To cancel use atrm against the created at job"
