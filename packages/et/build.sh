TERMUX_PKG_HOMEPAGE=https://eternalterminal.dev
TERMUX_PKG_DESCRIPTION="A remote shell that automatically reconnects without interrupting the session"
TERMUX_PKG_LICENSE="Apache-2.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_UPDATE_VERSION_REGEXP="\d+\.\d+\.\d+"
TERMUX_PKG_VERSION=6.2.0
TERMUX_PKG_SRCURL=https://github.com/MisterTea/EternalTerminal/archive/et-v${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=e16e2faf98e4471ea3db03aab7c607763ad172add720e00a40c6848de876b35a
TERMUX_PKG_DEPENDS="libc++, protobuf, libsodium, openssl"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="-DDISABLE_VCPKG=1"

termux_step_pre_configure() {
	termux_setup_protobuf
}

termux_step_post_make_install() {
	install -Dm600 $TERMUX_PKG_SRCDIR/etc/et.cfg $TERMUX_PREFIX/etc/
}
