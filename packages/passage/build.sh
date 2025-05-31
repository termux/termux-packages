TERMUX_PKG_HOMEPAGE=https://github.com/FiloSottile/passage
TERMUX_PKG_DESCRIPTION="A fork of password-store that uses age as backend"
TERMUX_PKG_LICENSE="GPL-2.0-or-later"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=1.7.4a2
TERMUX_PKG_REVISION=1
TERMUX_PKG_SRCURL=https://github.com/FiloSottile/passage/archive/refs/tags/$TERMUX_PKG_VERSION.tar.gz
TERMUX_PKG_SHA256=d4bd97be2eda4249b31c2042707ef70ba50385f6fb7791598f51be794168ee2c
TERMUX_PKG_DEPENDS="bash, age, tree"
TERMUX_PKG_RECOMMENDS="git"
TERMUX_PKG_SUGGESTS="pass-otp"
TERMUX_PKG_BUILD_IN_SRC=true
TERMUX_PKG_PLATFORM_INDEPENDENT=true
TERMUX_PKG_EXTRA_MAKE_ARGS="WITH_ALLCOMP=yes"

termux_step_post_configure() {
	# Replace $PREFIX with $PASS_PREFIX
	# to avoid variable name conflicts with Termux's $PREFIX
	# See: https://github.com/termux/termux-packages/issues/23569
	sed -i "s|PREFIX|PASS_PREFIX|g" src/password-store.sh
}
