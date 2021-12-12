# Builds fail in "ninja install"
TERMUX_PKG_HOMEPAGE=https://wiki.gnome.org/Apps/FileRoller
TERMUX_PKG_DESCRIPTION="File Roller is an archive manager for the GNOME desktop environment."
TERMUX_PKG_LICENSE="GPL-2.0"
TERMUX_PKG_MAINTAINER="Yisus7u7 <jesuspixel5@gmail.com>"
TERMUX_PKG_VERSION=3.40.0
TERMUX_PKG_REVISION=1
TERMUX_PKG_SRCURL=https://github.com/GNOME/file-roller/archive/refs/tags/${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=81e72121430ba6ea7396fe84d75b07252e550674addfb38bc6066665170941f3
TERMUX_PKG_DEPENDS="bzip2, desktop-file-utils, cpio, glib, gtk3, gzip, libcairo, lzip, lzop, p7zip, tar, unrar, unzip, xz-utils, zip, bsdtar, zlib, json-glib, libnotify, libarchive"
TERMUX_PKG_RM_AFTER_INSTALL="share/glib-2.0/schemas/gschemas.compiled"
