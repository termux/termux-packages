#!@TERMUX_PREFIX@/bin/sh

cat << EOF
If you have installed this package for Prism Launcher, follow these steps to use its native libraries:

1. Go to your instance, then click "Settings" and "Tweaks"
2. Check "Use system installation of OpenAL"
3. Put the following to the field of OpenAL path:

   @TERMUX_PREFIX@/lib/libopenal.so
EOF
