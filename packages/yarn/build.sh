TERMUX_PKG_HOMEPAGE=https://yarnpkg.com/
TERMUX_PKG_DESCRIPTION="Fast, reliable, and secure dependency management"
TERMUX_PKG_LICENSE="BSD 2-Clause"
TERMUX_PKG_MAINTAINER="Pierre Rudloff @Rudloff"
TERMUX_PKG_VERSION=1.17.0
TERMUX_PKG_SRCURL=https://yarnpkg.com/downloads/${TERMUX_PKG_VERSION}/yarn-v${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=c7ec0f1a2028c0f9a21d27fa1a689b5730d13ddcd3a145f3a2db50ebf98e65cc
TERMUX_PKG_DEPENDS="nodejs | nodejs-lts"
TERMUX_PKG_BUILD_IN_SRC=yes
TERMUX_PKG_PLATFORM_INDEPENDENT=yes

termux_step_make_install() {
	cp -r . ${TERMUX_PREFIX}/share/yarn/
	ln -f -s ../share/yarn/bin/yarn ${TERMUX_PREFIX}/bin/yarn
}
