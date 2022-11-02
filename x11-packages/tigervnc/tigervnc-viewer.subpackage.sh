TERMUX_SUBPKG_INCLUDE="
bin/vncviewer
share/applications
share/icons
share/man/man1/vncviewer.1
"
TERMUX_SUBPKG_DESCRIPTION="A VNC viewer from TigerVNC package"
TERMUX_SUBPKG_DEPEND_ON_PARENT=no
TERMUX_SUBPKG_DEPENDS="fltk, libandroid-shmem, libc++, libgnutls, libjpeg-turbo, libx11, libxext, libxrender, zlib"
TERMUX_SUBPKG_CONFLICTS="tigervnc (<< 1.9.0-4)"
