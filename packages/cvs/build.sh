TERMUX_PKG_HOMEPAGE=http://www.nongnu.org/cvs/
TERMUX_PKG_DESCRIPTION="Concurrent Versions System"
TERMUX_PKG_VERSION=1.11.23
TERMUX_PKG_SRCURL=http://ftp.gnu.org/non-gnu/cvs/source/stable/${TERMUX_PKG_VERSION}/cvs-${TERMUX_PKG_VERSION}.tar.bz2
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="--disable-server"
TERMUX_PKG_RM_AFTER_INSTALL="bin/cvsbug share/man/man8/cvsbug.8"
