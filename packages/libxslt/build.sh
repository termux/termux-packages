TERMUX_PKG_HOMEPAGE=http://xmlsoft.org/libxslt/
TERMUX_PKG_DESCRIPTION="XSLT processing library"
TERMUX_PKG_VERSION=1.1.28
TERMUX_PKG_BUILD_REVISION=3
TERMUX_PKG_SRCURL=ftp://xmlsoft.org/libxslt/libxslt-${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="--without-python"
TERMUX_PKG_DEPENDS="libxml2,libgcrypt"
TERMUX_PKG_INCLUDE_IN_DEVPACKAGE="bin/xslt-config lib/xsltConf.sh"
