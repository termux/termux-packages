TERMUX_PKG_HOMEPAGE=https://eternalterminal.dev
TERMUX_PKG_DESCRIPTION="A remote shell that automatically reconnects without interrupting the session"
TERMUX_PKG_LICENSE="Apache-2.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=6.0.13
TERMUX_PKG_REVISION=2
TERMUX_PKG_SRCURL=https://github.com/MisterTea/EternalTerminal/archive/et-v${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=728c3a444d666897c710e33fe473d8d289263a59574451b13aa53ec3c6ac88b3
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_AUTO_UPDATE_TAG_REGEXP="\d+\.\d+\.\d+"
TERMUX_PKG_DEPENDS="libc++, protobuf, libsodium"

termux_step_pre_configure() {
	termux_setup_protobuf
}

termux_step_post_make_install() {
	install -Dm600 $TERMUX_PKG_SRCDIR/etc/et.cfg $TERMUX_PREFIX/etc/
}
