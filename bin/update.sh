#!/bin/bash
# update.sh - aggiorna authorized_keys usando chiavi dei peer


bash /usr/local/bin/await.sh $0 || exit

REPLICA_USER="replica"
SSH_DIR="/home/$REPLICA_USER/.ssh"
KEYS_DIR="/var/lib/aeterna/data/_ssh/mirrors"
AUTHORIZED_KEYS="$SSH_DIR/authorized_keys"



echo "User: $USER"
whoami
id -un
ls -la /home/replica/.ssh/
echo "--"

exit

# Concatenazione di tutte le chiavi pubbliche dei peer
# shellcheck disable=SC2188
> "$AUTHORIZED_KEYS"

for f in "$KEYS_DIR"/*.pub; do
    if [ -f "$f" ]; then
      cat "$f" >> "$AUTHORIZED_KEYS"
         echo "Adding file: $f"
   fi
done

echo "----"
cat "$AUTHORIZED_KEYS"
echo "----"

echo "authorized_keys aggiornato"
