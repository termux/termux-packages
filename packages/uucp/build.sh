TERMUX_PKG_HOMEPAGE=https://www.airs.com/ian/uucp.html
TERMUX_PKG_DESCRIPTION="The standard UUCP package of the Free Software Foundation"
TERMUX_PKG_LICENSE="GPL-2.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=1.07
TERMUX_PKG_REVISION=1
TERMUX_PKG_SRCURL=ftp://ftp.gnu.org/pub/gnu/uucp/uucp-${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=060c15bfba6cfd1171ad81f782789032113e199a5aded8f8e0c1c5bd1385b62c
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
--infodir=$TERMUX_PREFIX/share/info
--mandir=$TERMUX_PREFIX/share/man
"
