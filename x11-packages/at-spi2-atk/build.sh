TERMUX_PKG_HOMEPAGE=https://wiki.linuxfoundation.org/accessibility/atk/at-spi/at-spi_on_d-bus
TERMUX_PKG_DESCRIPTION="A GTK+ module that bridges ATK to D-Bus at-spi"
TERMUX_PKG_LICENSE="GPL-2.0"
TERMUX_PKG_VERSION=2.38.0
TERMUX_PKG_REVISION=1
TERMUX_PKG_SRCURL=https://gitlab.gnome.org/GNOME/at-spi2-atk.git
TERMUX_PKG_GIT_BRANCH=AT_SPI2_ATK_${TERMUX_PKG_VERSION//./_}
TERMUX_PKG_DEPENDS="dbus, glib, atk, libxtst"
