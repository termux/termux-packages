TERMUX_PKG_HOMEPAGE=https://yarnpkg.com/
TERMUX_PKG_DESCRIPTION="Fast, reliable, and secure dependency management"
TERMUX_PKG_LICENSE="BSD 2-Clause"
TERMUX_PKG_MAINTAINER="Pierre Rudloff @Rudloff"
TERMUX_PKG_VERSION=1.19.2
TERMUX_PKG_SRCURL=https://yarnpkg.com/downloads/${TERMUX_PKG_VERSION}/yarn-v${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=2ed90e6aaf3988df5c75b6829b7c523754453a0b7134a9d0bf11161f927eae25
TERMUX_PKG_DEPENDS="nodejs | nodejs-lts"
TERMUX_PKG_BUILD_IN_SRC=true
TERMUX_PKG_PLATFORM_INDEPENDENT=true

termux_step_make_install() {
	cp -r . ${TERMUX_PREFIX}/share/yarn/
	ln -f -s ../share/yarn/bin/yarn ${TERMUX_PREFIX}/bin/yarn
}
