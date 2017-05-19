TERMUX_PKG_HOMEPAGE=http://dag.wiee.rs/home-made/dstat/
TERMUX_PKG_DESCRIPTION="Versatile resource statistics tool"
TERMUX_PKG_VERSION=0.7.3
TERMUX_PKG_DEPENDS="python2"
TERMUX_PKG_SRCURL=https://github.com/dagwieers/dstat/archive/${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_FOLDERNAME=dstat-${TERMUX_PKG_VERSION}
TERMUX_PKG_EXTRA_MAKE_ARGS="prefix=${TERMUX_PREFIX}"
TERMUX_PKG_BUILD_IN_SRC=yes
