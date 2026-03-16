#!/usr/bin/env bash
export QNX_BASE="$HOME/qnx800"
export QNX_HOST="$QNX_BASE/host/linux/x86_64"
export QNX_TARGET="$QNX_BASE/target/qnx"

export PATH="$QNX_HOST/usr/bin:$PATH"
export LD_LIBRARY_PATH="$QNX_HOST/usr/lib:$LD_LIBRARY_PATH"
export MAKEFLAGS="-j$(nproc)"

echo "QNX environment loaded:"
echo "QNX_BASE=$QNX_BASE"
echo "QNX_HOST=$QNX_HOST"
echo "QNX_TARGET=$QNX_TARGET"
