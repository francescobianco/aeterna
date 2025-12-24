#!/bin/bash
set -e

NODE_URL="http://localhost:9915/"
USER="aeterna"
PASS="Secret1234!"
LOCAL_FILE="tests/fixtures/file1.txt"

touch $LOCAL_FILE

curl -s -u "$USER:$PASS" "$NODE_URL" >/dev/null

curl -s -T "$LOCAL_FILE" -u "$USER:$PASS" "$NODE_URL" >/dev/null

