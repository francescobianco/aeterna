#!/bin/bash
set -e

NODE1="http://localhost:9915/"
USER1="aeterna"
PASS1="Secret1234!"

NODE2="http://localhost:9925/"
USER2="aeterna"
PASS2="Secret1234!"

LOCAL_FILE="tests/fixtures/file1.txt"
touch $LOCAL_FILE

curl -s -u "$USER1:$PASS1" "$NODE1" >/dev/null
curl -s -u "$USER2:$PASS2" "$NODE2" >/dev/null

curl -s -u "$USER1:$PASS1" "$NODE1/_ssh/id_rsa.pub" -o tests/nodes/pub_key_1
curl -s -T "tests/nodes/pub_key_1" -u "$USER2:$PASS2" "$NODE2/_ssh/_mirror/" >/dev/null
curl -s -u "$USER2:$PASS2" "$NODE2/cgi-bin/update_keys.cgi"


#curl -s -T "$LOCAL_FILE" -u "$USER1:$PASS1" "$NODE1" >/dev/null
