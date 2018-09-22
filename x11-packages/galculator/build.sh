TERMUX_PKG_MAINTAINER="Leonid Plyushch <leonid.plyushch@gmail.com> @xeffyr"

TERMUX_PKG_HOMEPAGE=http://galculator.sourceforge.net/
TERMUX_PKG_DESCRIPTION="GTK+ based scientific calculator"
TERMUX_PKG_VERSION=2.1.4
TERMUX_PKG_REVISION=2
TERMUX_PKG_SRCURL=http://galculator.mnim.org/downloads/galculator-${TERMUX_PKG_VERSION}.tar.bz2
TERMUX_PKG_SHA256=01cfafe6606e7ec45facb708ef85efd6c1e8bb41001a999d28212a825ef778ae
TERMUX_PKG_DEPENDS="libgtk3"

termux_step_pre_configure() {
    export LIBS="-landroid-shmem"
}
