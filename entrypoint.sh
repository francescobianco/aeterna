#!/bin/bash
set -e

# Start cron in background
service cron start

mkdir -p /var/lib/aeterna/data
chown -R www-data:www-data /var/lib/aeterna/data

apache2ctl configtest

# Start Apache in foreground
apachectl -D FOREGROUND
