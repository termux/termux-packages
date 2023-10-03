TERMUX_PKG_HOMEPAGE=https://sourceforge.net/projects/dict/
TERMUX_PKG_DESCRIPTION="Provides many low-level data structures which are helpful for writing compilers"
TERMUX_PKG_LICENSE="GPL-2.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="1.4.7"
TERMUX_PKG_SRCURL=https://downloads.sourceforge.net/project/dict/libmaa/libmaa-${TERMUX_PKG_VERSION}/libmaa-${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=4e01a9ebc5d96bc9284b6706aa82bddc2a11047fa9bd02e94cf8753ec7dcb98e
TERMUX_PKG_AUTO_UPDATE=true

termux_step_pre_configure() {
	autoreconf -ivf
}
