#!/usr/bin/env sh

# For further details see:
# https://github.com/termux/termux-packages/issues/22328
# https://github.com/termux/termux-packages/wiki/Common-porting-problems#android-dynamic-linker
# https://github.com/android/ndk/issues/201
#
# Shim to properly expose LuaJIT runtime symbols to dynamically linked plugin modules
LD_PRELOAD="$LD_PRELOAD:$PREFIX/lib/libluajit.so" exec "$PREFIX/libexec/nvim" "$@"
