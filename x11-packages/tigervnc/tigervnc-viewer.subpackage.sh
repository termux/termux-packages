TERMUX_SUBPKG_INCLUDE="
bin/vncviewer
share/applications
share/icons
share/man/man1/vncviewer.1
"

TERMUX_SUBPKG_DESCRIPTION="A VNC viewer from TigerVNC package"
TERMUX_SUBPKG_DEPENDS="fltk, fontconfig, libandroid-shmem, libc++, libgnutls, libice, libjpeg-turbo, libsm, libx11, libxcursor, libxext, libxfixes, libxft, libxinerama, libxrender"
TERMUX_SUBPKG_CONFLICTS="tigervnc (<< 1.9.0-4)"
