TERMUX_PKG_HOMEPAGE=https://yarnpkg.com/
TERMUX_PKG_DESCRIPTION="Fast, reliable, and secure dependency management"
TERMUX_PKG_DEPENDS="nodejs"
TERMUX_PKG_VERSION=1.2.1
TERMUX_PKG_SRCURL=https://yarnpkg.com/downloads/${TERMUX_PKG_VERSION}/yarn-v${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=f8ed07675c3a0b866e11a02af5c15d2f34c3aa261ab1501943ecee328786c959
TERMUX_PKG_BUILD_IN_SRC=yes
TERMUX_PKG_MAINTAINER="Pierre Rudloff @Rudloff"
TERMUX_PKG_PLATFORM_INDEPENDENT=yes

termux_step_make_install () {
    cp -r . ${TERMUX_PREFIX}/share/yarn/
    ln -s ../share/yarn/bin/yarn ${TERMUX_PREFIX}/bin/yarn
}
