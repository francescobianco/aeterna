#!/bin/bash

# Header CGI obbligatorio
echo "Content-type: text/plain"
echo ""

bash /usr/local/bin/sync.sh 2>&1
