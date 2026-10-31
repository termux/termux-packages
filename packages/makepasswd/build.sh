TERMUX_PKG_HOMEPAGE="https://github.com/khorben/makepasswd/"
TERMUX_PKG_DESCRIPTION="CLI password generator."
TERMUX_PKG_LICENSE="GPL-3.0"
TERMUX_PKG_MAINTAINER="Anon"
TERMUX_PKG_VERSION="0.5.4"
TERMUX_PKG_SRCURL="https://github.com/khorben/makepasswd/archive/makepasswd_${TERMUX_PKG_VERSION//./-}/makepasswd-makepasswd_${TERMUX_PKG_VERSION//./-}.tar.gz"
TERMUX_PKG_SHA256=7c68f42f810144c4380c795106a38cbb3cea20816b8903cdbc822cae99996e75
TERMUX_PKG_DEPENDS="docbook-xsl,docbook-xml,xsltproc,libxml2-utils"
TERMUX_PKG_BUILD_IN_SRC=true


termux_step_make_install() {
make PREFIX=$TERMUX_PREFIX DATADIR=$TERMUX_PREFIX/usr MANDIR=$TERMUX_PREFIX/usr/man install
    }
