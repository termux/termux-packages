TERMUX_PKG_HOMEPAGE=https://wiki.linuxfoundation.org/accessibility/atk/at-spi/at-spi_on_d-bus
TERMUX_PKG_DESCRIPTION="A GTK+ module that bridges ATK to D-Bus at-spi"
TERMUX_PKG_LICENSE="LGPL-2.1"
TERMUX_PKG_MAINTAINER="@termux"
_MAJOR_VERSION=2.38
TERMUX_PKG_VERSION=${_MAJOR_VERSION}.0
TERMUX_PKG_REVISION=6
TERMUX_PKG_SRCURL=https://download.gnome.org/sources/at-spi2-atk/${_MAJOR_VERSION}/at-spi2-atk-${TERMUX_PKG_VERSION}.tar.xz
TERMUX_PKG_SHA256=cfa008a5af822b36ae6287f18182c40c91dd699c55faa38605881ed175ca464f
TERMUX_PKG_DEPENDS="at-spi2-core, dbus, glib, atk"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
-Dtests=false
"
