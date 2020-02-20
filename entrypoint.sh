#!/bin/bash

name="${DOCKER_USER:-user}"
uid="${DOCKER_UID:-9001}"
IFS=: read -ra rw_dirs <<< "$DOCKER_USER_RW_DIRS"

export HOME=/home/"$name"
adduser -D -s /bin/bash -u "$uid" "$name"
for d in "${rw_dirs[@]}"; do
    echo "Fixing r/w permissions on $d" >/dev/stderr
    mkdir -p "$d"
    find "$d" \! -user "$name" -exec chown "$name:$name" {} \;
done

cmd=( "$@" )
(( ${#cmd[@]} == 0 )) && cmd=( /bin/bash )

echo "Starting with UID: $uid ($name)" >/dev/stderr
echo "Command: ${cmd[*]}" >/dev/stderr
exec /usr/bin/gosu "$name" "${cmd[@]}"
