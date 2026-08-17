TERMUX_PKG_HOMEPAGE=https://mate-desktop.org/
TERMUX_PKG_DESCRIPTION="File archiver for MATE"
TERMUX_PKG_LICENSE="GPL-2.0-or-later"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="1.28.5"
TERMUX_PKG_SRCURL="https://github.com/mate-desktop/engrampa/releases/download/v$TERMUX_PKG_VERSION/engrampa-$TERMUX_PKG_VERSION.tar.xz"
TERMUX_PKG_SHA256=38df10e6b0d7e54adc9b03d707518544871535669267b4d39d85d1ed985dd013
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_DEPENDS="gtk3, gzip, gettext, libarchive, tar, unzip, zip"
TERMUX_PKG_RECOMMENDS="caja, 7zip, unrar, brotli, rpm, cpio"
TERMUX_PKG_BUILD_DEPENDS="autoconf-archive, caja, glib, mate-common, python"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
--disable-packagekit
"
