#!@TERMUX_PREFIX@/bin/sh

cat << EOF
NOTE: If you have installed this package for Prism Launcher, make sure you replaced the LWJGL metadata in your instance with the one this package serves.

You can find the modified metadata in "@TERMUX_PREFIX@/share/java/lwjgl3/<VERSION>/prism-metadata".

If your LWJGL metadata contains either spvc, shaderc and/or jemalloc modules, make sure you installed the necessary dependencies. You can do it by running:

pkg install spirv-cross shaderc libjemalloc
EOF
