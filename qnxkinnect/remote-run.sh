#!/usr/bin/env bash
set -e

# Usage:
# ./remote-run.sh user@host /remote/path binary_to_run

REMOTE_USER_HOST="$1"
REMOTE_PATH="$2"
RUN_BINARY="$3"

if [[ -z "$REMOTE_USER_HOST" || -z "$REMOTE_PATH" || -z "$RUN_BINARY" ]]; then
  echo "Usage: $0 user@host /remote/path binary_to_run"
  exit 1
fi

source ./qnx-env.sh

echo "Building QNX project..."
make clean
make

echo "Collecting built binaries..."
BINARIES=$(find build -maxdepth 1 -type f -executable)

if [[ -z "$BINARIES" ]]; then
  echo "Error: no executables found in build/"
  exit 1
fi

if [[ ! -x "build/$RUN_BINARY" ]]; then
  echo "Error: requested binary '$RUN_BINARY' not found in build/"
  echo "Available binaries:"
  ls -1 build
  exit 1
fi

echo "Stopping previous instances..."
ssh "$REMOTE_USER_HOST" "
    slay -f parent child1 child2 2>/dev/null || true
    rm -f $REMOTE_PATH/parent $REMOTE_PATH/child1 $REMOTE_PATH/child2
"

echo "Deploying binaries:"
echo "$BINARIES"

scp -C $BINARIES "$REMOTE_USER_HOST:$REMOTE_PATH/"

echo "Running '$RUN_BINARY' remotely..."
ssh "$REMOTE_USER_HOST" "
  chmod +x $REMOTE_PATH/* &&
  exec $REMOTE_PATH/$RUN_BINARY
"
