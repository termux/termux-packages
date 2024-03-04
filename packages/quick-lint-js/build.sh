TERMUX_PKG_HOMEPAGE=https://quick-lint-js.com/
TERMUX_PKG_DESCRIPTION="Finds bugs in JavaScript programs"
TERMUX_PKG_LICENSE="GPL-3.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="3.2.0"
TERMUX_PKG_SRCURL=git+https://github.com/quick-lint/quick-lint-js
TERMUX_PKG_GIT_BRANCH=$TERMUX_PKG_VERSION
TERMUX_PKG_DEPENDS="libc++"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="-DBUILD_TESTING=OFF -DQUICK_LINT_JS_USE_BUILD_TOOLS=$TERMUX_PKG_HOSTBUILD_DIR/build-tools/"
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_HOSTBUILD=true

termux_step_host_build() {
	# https://quick-lint-js.com/contribute/build-from-source/cross-compiling/
	termux_setup_cmake
	cmake -DCMAKE_BUILD_TYPE=Release -S "$TERMUX_PKG_SRCDIR" -B build-tools $TERMUX_PKG_EXTRA_HOSTBUILD_CONFIGURE_ARGS
	make -C build-tools quick-lint-js-build-tools $TERMUX_PKG_EXTRA_MAKE_ARGS
}
