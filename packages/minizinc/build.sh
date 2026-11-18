TERMUX_PKG_HOMEPAGE="https://github.com/MiniZinc/libminizinc"
TERMUX_PKG_DESCRIPTION="A medium-level constraint modelling language"
TERMUX_PKG_GROUPS="science"
TERMUX_PKG_LICENSE="MPL-2.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="2.11.0"
TERMUX_PKG_SRCURL="https://github.com/MiniZinc/libminizinc/archive/refs/tags/$TERMUX_PKG_VERSION.tar.gz"
TERMUX_PKG_SHA256=9c88aa270864d78c4f39437533796f5bf60bf71bec78f02685742b2c44aeba26
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_DEPENDS="libandroid-spawn, libc++, zlib, gecode"

termux_step_pre_configure() {
	LDFLAGS+=" -landroid-spawn"
}
