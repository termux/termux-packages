TERMUX_SUBPKG_DESCRIPTION="nested X server"
TERMUX_SUBPKG_DEPEND_ON_PARENT="no"
TERMUX_SUBPKG_DEPENDS="libandroid-shmem, libpixman, libxau, libxcb, libxdmcp, libxfont2, opengl, openssl, xorg-xkbcomp, xcb-util, xcb-util-image, xcb-util-keysyms, xcb-util-renderutil, xcb-util-wm"
TERMUX_SUBPKG_INCLUDE="
bin/Xephyr
share/man/man1/Xephyr.1.gz
"
