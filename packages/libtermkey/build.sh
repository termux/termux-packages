TERMUX_PKG_HOMEPAGE=http://www.leonerd.org.uk/code/libtermkey/
TERMUX_PKG_DESCRIPTION="Library for processing of keyboard entry for terminal-based programs"
TERMUX_PKG_LICENSE="MIT"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=0.22
TERMUX_PKG_REVISION=3
TERMUX_PKG_SRCURL=http://www.leonerd.org.uk/code/libtermkey/libtermkey-${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=6945bd3c4aaa83da83d80a045c5563da4edd7d0374c62c0d35aec09eb3014600
TERMUX_PKG_DEPENDS="libunibilium"
TERMUX_PKG_BREAKS="libtermkey-dev"
TERMUX_PKG_REPLACES="libtermkey-dev"
TERMUX_PKG_BUILD_IN_SRC=true

termux_step_pre_configure() {
	CFLAGS+=" -std=c99 -DHAVE_UNIBILIUM=1"
}

termux_step_make() {
	$CC $CFLAGS $CPPFLAGS -c -fPIC termkey.c -o termkey.o
	$CC $CFLAGS $CPPFLAGS -c -fPIC driver-csi.c -o driver-csi.o
	$CC $CFLAGS $CPPFLAGS -c -fPIC driver-ti.c -o driver-ti.o

	$CC -shared -fPIC $LDFLAGS -o libtermkey.so \
		termkey.o driver-csi.o driver-ti.o -lunibilium
}

termux_step_make_install() {
	install -Dm600 -t $TERMUX_PREFIX/lib libtermkey.so
	chmod u+w termkey.h
	install -Dm600 termkey.h $TERMUX_PREFIX/include/
	LIBDIR=$TERMUX_PREFIX/lib INCDIR=$TERMUX_PREFIX/include VERSION=$TERMUX_PKG_VERSION sh termkey.pc.sh > \
	        $PKG_CONFIG_LIBDIR/termkey.pc
}
