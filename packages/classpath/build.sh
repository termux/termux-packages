TERMUX_PKG_HOMEPAGE=http://www.gnu.org/software/classpath
TERMUX_PKG_DESCRIPTION="GNU Classpath"
TERMUX_PKG_VERSION=0.99
TERMUX_PKG_BUILD_REVISION=1
TERMUX_PKG_SRCURL=ftp://ftp.gnu.org/gnu/classpath/classpath-${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="--disable-jni --without-x --disable-gtk-peer --disable-plugin --disable-gconf-peer --disable-Werror"
