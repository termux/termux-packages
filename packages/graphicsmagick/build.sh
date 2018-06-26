TERMUX_PKG_HOMEPAGE=http://www.graphicsmagick.org/
TERMUX_PKG_DESCRIPTION="Collection of image processing tools"
TERMUX_PKG_VERSION=1.3.30
TERMUX_PKG_REVISION=1
TERMUX_PKG_SHA256=d965e5c6559f55eec76c20231c095d4ae682ea0cbdd8453249ae8771405659f1
# Bandwith limited on main ftp site, so it's asked to use sourceforge instead:
TERMUX_PKG_SRCURL=http://downloads.sourceforge.net/project/graphicsmagick/graphicsmagick/${TERMUX_PKG_VERSION}/GraphicsMagick-${TERMUX_PKG_VERSION}.tar.xz
TERMUX_PKG_DEPENDS="littlecms, libtiff, freetype, libjasper, libjpeg-turbo, libpng, libbz2, libxml2, liblzma"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="ac_cv_func_ftime=no
--with-fontpath=/system/fonts
--without-x"
TERMUX_PKG_RM_AFTER_INSTALL="bin/*-config share/man/man1/*-config.1"
