#!/bin/bash

# Calculate hash of build/web directory
HASH=$(find ./build/web -type f -exec md5sum {} \; | sort -k 2 | md5sum | cut -d' ' -f1)

# Replace placeholder in index.html with actual hash
sed -i.bak "s/const BUILD_HASH = null;/const BUILD_HASH = '$HASH';/" ./build/web/index.html

echo "Build hash: $HASH"
