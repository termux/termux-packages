TERMUX_PKG_HOMEPAGE=https://www.gnu.org/software/bc/
TERMUX_PKG_DESCRIPTION="Arbitrary precision numeric processing language"
TERMUX_PKG_LICENSE="GPL-2.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="1.08.1"
TERMUX_PKG_SRCURL=https://mirrors.kernel.org/gnu/bc/bc-${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=b71457ffeb210d7ea61825ff72b3e49dc8f2c1a04102bbe23591d783d1bfe996
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_DEPENDS="readline,flex"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
--infodir=$TERMUX_PREFIX/share/info
--mandir=$TERMUX_PREFIX/share/man
--with-readline
"
