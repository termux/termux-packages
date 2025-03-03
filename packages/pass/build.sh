TERMUX_PKG_HOMEPAGE=https://www.passwordstore.org
TERMUX_PKG_DESCRIPTION="Lightweight directory-based password manager"
TERMUX_PKG_LICENSE="GPL-2.0-or-later"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=1.7.4
TERMUX_PKG_REVISION=5
TERMUX_PKG_SRCURL=https://git.zx2c4.com/password-store/snapshot/password-store-${TERMUX_PKG_VERSION}.tar.xz
TERMUX_PKG_SHA256=cfa9faf659f2ed6b38e7a7c3fb43e177d00edbacc6265e6e32215ff40e3793c0
TERMUX_PKG_DEPENDS="bash, coreutils, gnupg (>= 2.2.9-1), tree"
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
