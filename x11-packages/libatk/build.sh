TERMUX_PKG_MAINTAINER="Leonid Plyushch <leonid.plyushch@gmail.com> @xeffyr"

TERMUX_PKG_HOMEPAGE=https://www.gtk.org
TERMUX_PKG_DESCRIPTION="The interface definitions of accessibility infrastructure"
_major=2.28
_minor=1
TERMUX_PKG_VERSION=${_major}.${_minor}
TERMUX_PKG_REVISION=1
TERMUX_PKG_SRCURL=http://ftp.gnome.org/pub/gnome/sources/atk/${_major}/atk-${TERMUX_PKG_VERSION}.tar.xz
TERMUX_PKG_SHA256=cd3a1ea6ecc268a2497f0cd018e970860de24a6d42086919d6bf6c8e8d53f4fc
TERMUX_PKG_DEPENDS="glib, libandroid-support"
