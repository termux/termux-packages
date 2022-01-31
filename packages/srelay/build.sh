TERMUX_PKG_HOMEPAGE=https://sourceforge.net/projects/socks-relay
TERMUX_PKG_DESCRIPTION="A Free SOCKS proxy server"
TERMUX_PKG_LICENSE="BSD"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=0.4.8p3
TERMUX_PKG_REVISION=6
TERMUX_PKG_SRCURL=http://downloads.sourceforge.net/sourceforge/socks-relay/srelay-${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=efa38cb3e9e745a05ccb4b59fcf5d041184f15dbea8eb80c1b0ce809bb00c924
TERMUX_PKG_DEPENDS="libcrypt"
TERMUX_PKG_BUILD_IN_SRC=true

TERMUX_PKG_CONFFILES="
etc/srelay.conf
etc/srelay.passwd
"

termux_step_pre_configure() {
	export CPPFLAGS="${CPPFLAGS} -DLINUX"
}

termux_step_make_install() {
	install -Dm755 srelay "${TERMUX_PREFIX}/bin/srelay"
	install -Dm644 srelay.conf "${TERMUX_PREFIX}/etc/srelay.conf"
	install -Dm644 srelay.passwd "${TERMUX_PREFIX}/etc/srelay.passwd"
	install -Dm644 srelay.8 "${TERMUX_PREFIX}/share/man/man8/srelay.8"
}

termux_step_install_license() {
	install -Dm600 -t "$TERMUX_PREFIX/share/doc/srelay" \
		"$TERMUX_PKG_BUILDER_DIR"/LICENSE.txt
}
