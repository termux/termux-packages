#!/bin/bash
if [ "$1" != "-cc1" ]; then
    $HOST_ROOTFS/$TERMUX_STANDALONE_TOOLCHAIN/bin/clang --target=$CCTERMUX_HOST_PLATFORM "$@"
else
    # Target is already an argument.
    $HOST_ROOTFS/$TERMUX_STANDALONE_TOOLCHAIN/bin/clang "$@"
fi
