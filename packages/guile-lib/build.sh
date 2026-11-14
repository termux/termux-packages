TERMUX_PKG_HOMEPAGE=https://www.nongnu.org/guile-lib/
TERMUX_PKG_DESCRIPTION="Collection of useful Guile Scheme modules"
TERMUX_PKG_LICENSE="GPL-3.0"
TERMUX_PKG_MAINTAINER="JesusChapman <developer@jesuschapman.me>"
TERMUX_PKG_VERSION=0.2.8
TERMUX_PKG_SRCURL=https://download.savannah.nongnu.org/releases/guile-lib/guile-lib-${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=64e902ee0cbb2cee1efb8168c3bf9ed49e0b32a8a23db863e83bf14817d767d9
TERMUX_PKG_DEPENDS="guile"
TERMUX_PKG_BUILD_IN_SRC=true
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="--with-guile-site=no"

termux_step_post_configure() {
	find . -name Makefile -exec sed -i "s|\${datarootdir}/guile-lib|${TERMUX_PREFIX}/share/guile/site/3.0|g" {} +
}
