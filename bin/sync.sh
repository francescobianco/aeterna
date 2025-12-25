#!/bin/bash
# sync_peers.sh - replica dati verso i peers via rsync over SSH

VOLUME_DIR="/var/lib/aeterna"
DATA_DIR="$VOLUME_DIR/data"
MIRRORS_DIR="$VOLUME_DIR/mirrors"

# Controllo base
[ ! -d "$DATA_DIR" ] && echo "Directory data non trovata" && exit 1

while IFS=: read -r HOST WEBDAV_PORT SSH_PORT; do
    [ -z "$HOST" ] && continue

    echo "Sync verso $HOST:$WEBDAV_PORT:$SSH_PORT"

   echo "Checking...." >&2
   # shellcheck disable=SC2095
   ssh -v -p "$SSH_PORT" -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null replica@$HOST date


echo "Syncing...."

    # Replica dati via rsync su SSH
#rsync -avvvz --progress --stats \
#  -e "ssh -vvv -p $SSH_PORT -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null \
#  "$DATA_DIR/" "replica@$HOST:$MIRRORS_DIR/$HOST/"

done < /etc/aeterna/mirrors.list

echo "Sync completato $(date)"
