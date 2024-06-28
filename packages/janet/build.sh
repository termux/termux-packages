TERMUX_PKG_HOMEPAGE=https://janet-lang.org
TERMUX_PKG_DESCRIPTION="Janet is a functional and imperative programming language."
TERMUX_PKG_LICENSE="MIT"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=1.35.0
TERMUX_PKG_SRCURL=https://github.com/janet-lang/janet/archive/refs/tags/v${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=81d619245040de151572f1c4cd01d4380aae656befed280d35e1fe3a4dd7b0af
TERMUX_PKG_DEPENDS="libandroid-spawn"
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_BUILD_IN_SRC=true

termux_step_configure() {
	TERMUX_PKG_EXTRA_MAKE_ARGS="PREFIX=${TERMUX_PREFIX}"
}

termux_step_make() {
	export CFLAGS="${CPPFLAGS} ${CFLAGS}"
	make -j "${TERMUX_PKG_MAKE_PROCESSES}" PREFIX="${TERMUX_PREFIX}"
}
