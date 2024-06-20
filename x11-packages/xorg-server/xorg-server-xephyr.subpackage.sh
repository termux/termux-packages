TERMUX_SUBPKG_DESCRIPTION="nested X server"
TERMUX_SUBPKG_DEPEND_ON_PARENT=false
TERMUX_SUBPKG_DEPENDS="libandroid-shmem, libpixman, libxau, libxcb, libxdmcp, libxfont2, opengl, openssl, xcb-util, xcb-util-image, xcb-util-keysyms, xcb-util-renderutil, xcb-util-wm, xkeyboard-config, xorg-xkbcomp"
TERMUX_SUBPKG_INCLUDE="
bin/Xephyr
share/man/man1/Xephyr.1.gz
"
