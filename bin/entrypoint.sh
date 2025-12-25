#!/bin/bash
set -e

# Start cron in background
service cron start

mkdir -p /etc/aeterna/
mkdir -p /var/lib/aeterna/data
mkdir -p /var/lib/aeterna/data/_ssh
mkdir -p /var/lib/aeterna/data/_ssh/mirror
mkdir -p /var/lib/aeterna/data/_trash
touch /var/lib/aeterna/data/_trash/_empty
chown -R www-data:www-data /var/lib/aeterna/data

printf "%s\n" "${AETERNA_MIRROR//,/\\n}" > /etc/aeterna/mirrors.list

if [ ! -f "/home/replica/.ssh/id_rsa" ]; then
    echo "Generazione chiavi SSH per $REPLICA_USER..."
    ssh-keygen -t rsa -b 4096 -N "" -f /home/replica/.ssh/id_rsa
fi

if [ ! -f "/var/lib/aeterna/data/_ssh/id_rsa.pub" ]; then
  cp /home/replica/.ssh/id_rsa.pub /var/lib/aeterna/data/_ssh/id_rsa.pub
  ls -l /var/lib/aeterna/data/_ssh/
fi

apache2ctl configtest

bash /usr/local/bin/sync.sh

# Start Apache in foreground
apachectl -D FOREGROUND
