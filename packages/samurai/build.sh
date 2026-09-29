TERMUX_PKG_HOMEPAGE="https://github.com/michaelforney/samurai"
TERMUX_PKG_DESCRIPTION="ninja-compatible build tool written in C"
TERMUX_PKG_LICENSE="Apache-2.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="1.3"
TERMUX_PKG_SRCURL="https://github.com/michaelforney/samurai/archive/refs/tags/$TERMUX_PKG_VERSION.tar.gz"
TERMUX_PKG_SHA256=44ff119a27b343ec47a797fa8701c19b9e672230bc15f3c6a6cede9641ea6332
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_DEPENDS="libandroid-spawn"
TERMUX_PKG_BUILD_IN_SRC=true

termux_step_pre_configure() {
	rm -f "build.ninja"
	export LDFLAGS+=" -landroid-spawn"
}
