#!/bin/bash
if [ "$1" != "-cc1" ]; then
    /host-rootfs/$TERMUX_STANDALONE_TOOLCHAIN/bin/clang --target=armv7a-linux-androideabi24 "$@"
else
    # Target is already an argument.
    /host-rootfs/$TERMUX_STANDALONE_TOOLCHAIN/bin/clang "$@"
fi
