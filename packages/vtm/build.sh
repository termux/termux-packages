TERMUX_PKG_HOMEPAGE=https://vtm.netxs.online/
TERMUX_PKG_DESCRIPTION="Terminal multiplexer with TUI window manager and multi-party session sharing"
TERMUX_PKG_LICENSE="MIT"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=0.5.15
TERMUX_PKG_REVISION=1
TERMUX_PKG_SRCURL=https://github.com/netxs-group/vtm/archive/refs/tags/v${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=fa18ae2f1eee9615c6e0df5be4b248fb15268c5e7401380f129ccee8cb9254f0
TERMUX_PKG_DEPENDS="libandroid-spawn"
TERMUX_PKG_BUILD_IN_SRC=true

termux_step_pre_configure() {
	TERMUX_PKG_SRCDIR+=/src
	CXXFLAGS+=" -pthread"
	LDFLAGS+=" -landroid-spawn"
}

termux_step_install_license() {
	install -Dm600 -t $TERMUX_PREFIX/share/doc/vtm \
		$TERMUX_PKG_SRCDIR/../LICENSE
}
