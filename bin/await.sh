#!/bin/bash

echo "Await: $@"

QUEUE_DIR="/tmp/await_queue"
mkdir -p "$QUEUE_DIR"

CURRENT_USER=$(whoami)

if [ "$CURRENT_USER" = "replica" ]; then
  echo "Exit 0"
  exit 0
else
  echo "Exit 1"


  exit 1
fi

