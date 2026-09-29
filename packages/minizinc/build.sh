TERMUX_PKG_HOMEPAGE="https://github.com/MiniZinc/libminizinc"
TERMUX_PKG_DESCRIPTION="A medium-level constraint modelling language"
TERMUX_PKG_GROUPS="science"
TERMUX_PKG_LICENSE="MPL-2.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="2.10.1"
TERMUX_PKG_SRCURL="https://github.com/MiniZinc/libminizinc/archive/refs/tags/$TERMUX_PKG_VERSION.tar.gz"
TERMUX_PKG_SHA256=089ea94698cea94ed8396be77559b82d828437a808f5e37d10bccc9f1d39dd33
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_DEPENDS="libandroid-spawn, libc++, zlib, gecode"

termux_step_pre_configure() {
	LDFLAGS+=" -landroid-spawn"
}
