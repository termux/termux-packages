#!/usr/bin/env sh

# For further details see:
# https://github.com/termux/termux-packages/issues/22328
# https://github.com/termux/termux-packages/wiki/Common-porting-problems#android-dynamic-linker
# https://github.com/android/ndk/issues/201
#
# Using /data/data/com.termux/files/usr to substitute full path at build time.
# This avoids a conflict with `pass`.
# See: https://github.com/termux/termux-packages/issues/23569
#
# Shim to properly expose LuaJIT runtime symbols to dynamically linked plugin modules
LD_PRELOAD="$LD_PRELOAD:@TERMUX_PREFIX@/lib/libluajit.so" exec "@TERMUX_PREFIX@/libexec/nvim/nvim" "$@"
