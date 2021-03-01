TERMUX_PKG_HOMEPAGE=https://sourceforge.net/projects/galculator/
TERMUX_PKG_DESCRIPTION="GTK+ based scientific calculator"
TERMUX_PKG_LICENSE="GPL-2.0"
TERMUX_PKG_MAINTAINER="Leonid Pliushch <leonid.pliushch@gmail.com>"
TERMUX_PKG_VERSION=2.1.4
TERMUX_PKG_REVISION=21
TERMUX_PKG_SRCURL=http://galculator.mnim.org/downloads/galculator-${TERMUX_PKG_VERSION}.tar.bz2
TERMUX_PKG_SHA256=01cfafe6606e7ec45facb708ef85efd6c1e8bb41001a999d28212a825ef778ae
TERMUX_PKG_DEPENDS="atk, gdk-pixbuf, glib, gtk3, libandroid-shmem, libcairo, pango"

termux_step_pre_configure() {
	export LIBS="-landroid-shmem"
}
