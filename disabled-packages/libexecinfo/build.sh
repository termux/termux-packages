TERMUX_PKG_HOMEPAGE=https://www.freshports.org/devel/libexecinfo
TERMUX_PKG_DESCRIPTION="A quick-n-dirty BSD licensed clone of backtrace facility found in the GNU libc"
TERMUX_PKG_LICENSE="BSD 2-Clause"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=1.1
TERMUX_PKG_SRCURL=http://distcache.FreeBSD.org/ports-distfiles/libexecinfo-${TERMUX_PKG_VERSION}.tar.bz2
TERMUX_PKG_SHA256=c9a21913e7fdac8ef6b33250b167aa1fc0a7b8a175145e26913a4c19d8a59b1f

# Apparently not working for these arches:
TERMUX_PKG_BLACKLISTED_ARCHES="i686, x86_64"

termux_step_post_get_source() {
	cp $TERMUX_PKG_BUILDER_DIR/LICENSE ./
}

termux_step_pre_configure() {
	CFLAGS+=" -fvisibility=hidden -fno-strict-aliasing"
	LDFLAGS+=" -lm"
}

termux_step_make() {
	local objs="execinfo.o stacktraverse.o"
	local f
	for f in $objs; do
		$CC $CFLAGS $CPPFLAGS "$TERMUX_PKG_SRCDIR/${f%.o}.c" -c
	done
	$CC $CFLAGS $objs -shared $LDFLAGS -o libexecinfo.so
	$AR cru libexecinfo.a $objs
}

termux_step_make_install() {
	install -Dm600 -t $TERMUX_PREFIX/lib libexecinfo.{a,so}
	install -Dm600 -t $TERMUX_PREFIX/include $TERMUX_PKG_SRCDIR/execinfo.h
}
