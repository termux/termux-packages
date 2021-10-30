TERMUX_PKG_HOMEPAGE=https://eternalterminal.dev
TERMUX_PKG_DESCRIPTION="A remote shell that automatically reconnects without interrupting the session"
TERMUX_PKG_LICENSE="Apache-2.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_AUTO_UPDATE_TAG_REGEXP="\d+\.\d+\.\d+"
TERMUX_PKG_VERSION=6.1.8
TERMUX_PKG_SRCURL=https://github.com/MisterTea/EternalTerminal/archive/et-v${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=c82c62722d5e4db5b4596bcaafd4a4cf8c236968cb3782f791f5c38a62b10fb9
TERMUX_PKG_DEPENDS="libc++, protobuf, libsodium, openssl"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="-DDISABLE_VCPKG=1"

termux_step_pre_configure() {
	termux_setup_protobuf
}

termux_step_post_make_install() {
	install -Dm600 $TERMUX_PKG_SRCDIR/etc/et.cfg $TERMUX_PREFIX/etc/
}
