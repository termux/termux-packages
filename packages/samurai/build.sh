TERMUX_PKG_HOMEPAGE="https://github.com/michaelforney/samurai"
TERMUX_PKG_DESCRIPTION="ninja-compatible build tool written in C"
TERMUX_PKG_LICENSE="Apache-2.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="1.2"
TERMUX_PKG_REVISION=1
TERMUX_PKG_SRCURL="https://github.com/michaelforney/samurai/archive/refs/tags/$TERMUX_PKG_VERSION.tar.gz"
TERMUX_PKG_SHA256=37a2d9f35f338c53387eba210bab7e5d8abe033492664984704ad84f91b71bac
TERMUX_PKG_DEPENDS="libandroid-spawn"
TERMUX_PKG_BUILD_IN_SRC=true

termux_step_pre_configure() {
	rm -f "build.ninja"
	export LDFLAGS+=" -landroid-spawn"
}
