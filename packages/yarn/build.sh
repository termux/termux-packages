TERMUX_PKG_HOMEPAGE=https://yarnpkg.com/
TERMUX_PKG_DESCRIPTION="Fast, reliable, and secure dependency management"
TERMUX_PKG_MAINTAINER="Pierre Rudloff @Rudloff"
TERMUX_PKG_DEPENDS="nodejs | nodejs-current"
TERMUX_PKG_VERSION=1.8.0
TERMUX_PKG_SHA256=3d8dc87cae99f7547b82026f818b3a14f0393cfa09337bb9adfb446d50a527a7
TERMUX_PKG_SRCURL=https://yarnpkg.com/downloads/${TERMUX_PKG_VERSION}/yarn-v${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_BUILD_IN_SRC=yes
TERMUX_PKG_PLATFORM_INDEPENDENT=yes

termux_step_make_install () {
	cp -r . ${TERMUX_PREFIX}/share/yarn/
	ln -f -s ../share/yarn/bin/yarn ${TERMUX_PREFIX}/bin/yarn
}
