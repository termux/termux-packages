TERMUX_PKG_HOMEPAGE=https://yarnpkg.com/
TERMUX_PKG_DESCRIPTION="Fast, reliable, and secure dependency management"
TERMUX_PKG_DEPENDS="nodejs"
TERMUX_PKG_VERSION=1.3.2
TERMUX_PKG_SHA256=6cfe82e530ef0837212f13e45c1565ba53f5199eec2527b85ecbcd88bf26821d
TERMUX_PKG_SRCURL=https://yarnpkg.com/downloads/${TERMUX_PKG_VERSION}/yarn-v${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_BUILD_IN_SRC=yes
TERMUX_PKG_MAINTAINER="Pierre Rudloff @Rudloff"
TERMUX_PKG_PLATFORM_INDEPENDENT=yes

termux_step_make_install () {
	cp -r . ${TERMUX_PREFIX}/share/yarn/
	ln -f -s ../share/yarn/bin/yarn ${TERMUX_PREFIX}/bin/yarn
}
