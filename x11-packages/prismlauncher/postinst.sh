#!@TERMUX_PREFIX@/bin/sh

cat << EOF
NOTE: If you want to play the older versions of Minecraft in Prism Launcher, you'll need the other versions of LWJGL. 

You can install them by:

"pkg install lwjgl3" OR "pkg install lwjgl3-<VERSION>" (LWJGL 3)

"pkg install lwjgl2" (LWJGL 2)

List of LWJGL versions compatible with Minecraft versions:

MC 1.12.2 or older: LWJGL 2.9.3
MC 1.13-1.15:       LWJGL 3.2.1
MC 1.16.x:          LWJGL 3.2.2
MC 1.17-1.19.4:     LWJGL 3.3.1
MC 1.20-1.20.6:     LWJGL 3.3.2 or 3.3.3
MC 1.21-1.21.x:     LWJGL 3.3.3
MC 26.1 and newer:  LWJGL 3.4.1 and newer
EOF
