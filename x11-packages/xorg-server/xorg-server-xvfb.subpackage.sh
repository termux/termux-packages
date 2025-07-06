TERMUX_SUBPKG_DESCRIPTION="X virtual framebuffer"
TERMUX_SUBPKG_DEPEND_ON_PARENT=false
TERMUX_SUBPKG_DEPENDS="libandroid-shmem, libdrm, libpixman, libx11, libxau, libxfont2, libxinerama, libxkbfile, libxshmfence, opengl, openssl, xkeyboard-config, xorg-protocol-txt, xorg-xkbcomp"
TERMUX_SUBPKG_CONFLICTS="xorg-xvfb"
TERMUX_SUBPKG_REPLACES="xorg-xvfb"
TERMUX_SUBPKG_INCLUDE="
bin/Xvfb
bin/xvfb-run
share/man/man1/Xvfb.1.gz
"
