#!/bin/bash
# update.sh - aggiorna authorized_keys usando chiavi dei peer

REPLICA_USER="replica"
SSH_DIR="/home/$REPLICA_USER/.ssh"
KEYS_DIR="/var/lib/aeterna/data/_ssh/mirror"
AUTHORIZED_KEYS="$SSH_DIR/authorized_keys"


# Concatenazione di tutte le chiavi pubbliche dei peer
> "$AUTHORIZED_KEYS"
for f in "$KEYS_DIR"/*.pub; do
    [ -f "$f" ] && cat "$f" >> "$AUTHORIZED_KEYS"
done

chmod 600 "$AUTHORIZED_KEYS"
chown $REPLICA_USER:$REPLICA_USER "$AUTHORIZED_KEYS"

echo "authorized_keys aggiornato"
