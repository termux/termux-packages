TERMUX_PKG_HOMEPAGE=https://github.com/termux/libandroid-support
TERMUX_PKG_DESCRIPTION="Library extending the Android C library (Bionic) for additional multibyte, locale and math support"
TERMUX_PKG_LICENSE="Apache-2.0"
TERMUX_PKG_VERSION=24
TERMUX_PKG_REVISION=4
TERMUX_PKG_SRCURL=https://github.com/termux/libandroid-support/archive/v$TERMUX_PKG_VERSION.tar.gz
TERMUX_PKG_SHA256=e14e262429a60bea733d5bed69d2f3a1cada53fcadaf76787fca5c8b0d4dae2f
TERMUX_PKG_PRE_DEPENDS="dpkg (>= 1.19.4-3)"
TERMUX_PKG_BUILD_IN_SRC=yes
TERMUX_PKG_ESSENTIAL=yes

termux_step_make() {
	local c_file

	mkdir objects
	for c_file in $(find src -type f -iname \*.c); do
		$CC $CPPFLAGS $CFLAGS -std=c99 -DNULL=0 -fPIC -Iinclude \
			-c $c_file -o ./objects/$(basename "$c_file").o
	done

	cd objects
	ar rcu ../libandroid-support.a
	$CC $LDFLAGS -shared -o ../libandroid-support.so *.o
}

termux_step_make_install() {
	install -Dm600 libandroid-support.a $TERMUX_PREFIX/lib/libandroid-support.a
	install -Dm600 libandroid-support.so $TERMUX_PREFIX/lib/libandroid-support.so
}
