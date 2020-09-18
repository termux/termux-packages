TERMUX_PKG_HOMEPAGE=https://github.com/akopytov/sysbench
TERMUX_PKG_DESCRIPTION=" Scriptable multi-threaded benchmark tool for databases and systems. Popular and used to benchmark many different systems."
TERMUX_PKG_LICENSE="GPL-2.0"
TERMUX_PKG_VERSION=1.0.20
TERMUX_PKG_SRCURL=https://github.com/akopytov/sysbench/archive/$TERMUX_PKG_VERSION.tar.gz
TERMUX_PKG_SHA256=e8ee79b1f399b2d167e6a90de52ccc90e52408f7ade1b9b7135727efe181347f
TERMUX_PKG_DEPENDS="luajit, libluajit, openssl, postgresql, libaio, concurrencykit"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="--with-pgsql --without-mysql --with-system-luajit --with-system-ck"
TERMUX_PKG_BUILD_IN_SRC=true

termux_step_pre_configure() {
	CPPFLAGS+=" -I${TERMUX_PKG_SRCDIR}/src"
	./autogen.sh 
}

