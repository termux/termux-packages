#!/bin/bash
if [ "$1" != "-cc1" ]; then
    /host-rootfs/$TERMUX_STANDALONE_TOOLCHAIN/bin/clang --target=aarch64-linux-android24 "$@"
else
    # Target is already an argument.
    /host-rootfs/$TERMUX_STANDALONE_TOOLCHAIN/bin/clang "$@"
fi
