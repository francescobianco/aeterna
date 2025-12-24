#!/bin/bash

NODE_URL="http://localhost:9915/"
USER="aeterna"
PASS="Secret1234!"
LOCAL_FILE="tests/fixtures/file1.txt"


curl -T "$LOCAL_FILE" -u "$USER:$PASS" "$NODE_URL"

