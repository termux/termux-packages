TERMUX_PKG_HOMEPAGE=https://www.gnu.org/software/cpio/
TERMUX_PKG_DESCRIPTION="CPIO implementation from the GNU project"
TERMUX_PKG_LICENSE="GPL-3.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=2.14
TERMUX_PKG_SRCURL=https://mirrors.kernel.org/gnu/cpio/cpio-$TERMUX_PKG_VERSION.tar.bz2
TERMUX_PKG_SHA256=fcdc15d60f7267a6fc7efcd6b9db7b6c8966c4f2fbbb964c24d41336fd3f2c12
TERMUX_PKG_DEPENDS="tar"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="--with-rmt=$TERMUX_PREFIX/libexec/rmt"

termux_step_pre_configure() {
	autoreconf -fi
}
