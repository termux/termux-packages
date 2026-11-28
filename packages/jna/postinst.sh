#!@TERMUX_PREFIX@/bin/sh

cat << EOF
If you have installed this package for Prism Launcher, make sure you have added this to Java arguments in your instance:

-Djna.boot.library.path=@TERMUX_PREFIX@/lib/jna
EOF
