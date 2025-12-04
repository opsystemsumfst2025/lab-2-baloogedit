#!/bin/bash

# 1. Store the directory argument
TARGET_DIR="$1"

# 2. Check if a directory was provided
if [ -z "$TARGET_DIR" ]; then
  echo "Error: No directory provided"
  exit 1
fi

# 3. Fix text files (Read/Write for user, Read for everyone else)
find "$TARGET_DIR" -name '*.txt' -exec chmod 644 {} \;

# 4. Fix scripts (Executable for user)
find "$TARGET_DIR" -name '*.sh' -exec chmod 700 {} \;

# 5. Log the action
echo "$(date): Permissions fixed in $TARGET_DIR" >> audit.log
