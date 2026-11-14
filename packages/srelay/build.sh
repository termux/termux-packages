TERMUX_PKG_HOMEPAGE=https://sourceforge.net/projects/socks-relay/
TERMUX_PKG_DESCRIPTION="A Free SOCKS proxy server"
TERMUX_PKG_LICENSE="BSD"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=0.4.9
TERMUX_PKG_SRCURL=http://downloads.sourceforge.net/sourceforge/socks-relay/srelay-${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=9dbc5b2cfa5cd4cb72d8d68408429937c800a7cd3d5da35e8b315bf6984d2edc
TERMUX_PKG_DEPENDS="libcrypt"
TERMUX_PKG_BUILD_IN_SRC=true

TERMUX_PKG_CONFFILES="
etc/srelay.conf
etc/srelay.passwd
"

termux_step_pre_configure() {
	autoreconf -fi

	export CPPFLAGS="${CPPFLAGS} -DLINUX"
}

termux_step_make_install() {
	install -Dm755 srelay "${TERMUX_PREFIX}/bin/srelay"
	install -Dm644 srelay.conf "${TERMUX_PREFIX}/etc/srelay.conf"
	install -Dm644 srelay.passwd "${TERMUX_PREFIX}/etc/srelay.passwd"
	install -Dm644 srelay.8 "${TERMUX_PREFIX}/share/man/man8/srelay.8"
}

termux_step_install_license() {
	install -Dm600 -t "$TERMUX_PREFIX/share/doc/$TERMUX_PKG_NAME" \
		"$TERMUX_PKG_BUILDER_DIR"/LICENSE.txt
}
