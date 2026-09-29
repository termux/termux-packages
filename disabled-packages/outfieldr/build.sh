TERMUX_PKG_HOMEPAGE=https://gitlab.com/ve-nt/outfieldr
TERMUX_PKG_DESCRIPTION="A TLDR client in Zig"
TERMUX_PKG_LICENSE="MIT"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=1.0.3
TERMUX_PKG_SRCURL=git+https://gitlab.com/ve-nt/outfieldr
TERMUX_PKG_GIT_BRANCH=$TERMUX_PKG_VERSION
TERMUX_PKG_DEPENDS="libc++"
TERMUX_PKG_BUILD_IN_SRC=true
TERMUX_PKG_EXCLUDED_ARCHES="arm, i686"
TERMUX_ZIG_VERSION="0.9.1"

termux_step_make() {
	termux_setup_zig
	ZIG_TARGET_NAME=${TERMUX_ARCH}-linux-android
	zig build -Dtarget=$ZIG_TARGET_NAME
}

termux_step_make_install() {
	install -Dm700 -t $TERMUX_PREFIX/bin bin/tldr
}
