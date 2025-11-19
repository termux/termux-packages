#!@TERMUX_PREFIX@/bin/sh
case "$1" in
purge|remove)
rm -fr "@TERMUX_PREFIX@/opt/emscripten"
esac
