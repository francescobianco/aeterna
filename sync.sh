#!/bin/bash
# sync_peers.sh - replica dati verso i peers via rsync over SSH

VOLUME_DIR="/var/lib/aeterna"
DATA_DIR="$VOLUME_DIR/data"
MIRRORS_DIR="$VOLUME_DIR/mirrors"
PEERS_FILE="$VOLUME_DIR/peers.conf"

# Controllo base
[ ! -d "$DATA_DIR" ] && echo "Directory data non trovata" && exit 1

# Loop sui peers
echo "${AETERNA_MIRROR}" | while IFS=: read -r HOST WEB_PORT SSH_PORT
do
    [ -z "$HOST" ] && continue

    echo "Sync verso $HOST (ssh_port=$SSH_PORT)"

    # Replica dati via rsync su SSH
    rsync -az -e "ssh -p $SSH_PORT -o StrictHostKeyChecking=no" \
        "$DATA_DIR/" "user@$HOST:$MIRRORS_DIR/$HOST/"

done

echo "Sync completato $(date)"
