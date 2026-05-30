TERMUX_PKG_HOMEPAGE=http://smalltalk.gnu.org/
TERMUX_PKG_DESCRIPTION="A free implementation of the Smalltalk-80 language"
TERMUX_PKG_LICENSE="GPL-2.0, LGPL-2.1"
TERMUX_PKG_MAINTAINER="Henrik Grimler @Grimler91"
TERMUX_PKG_VERSION="3.2.91"
TERMUX_PKG_REVISION=16
TERMUX_PKG_SRCURL="ftp://alpha.gnu.org/gnu/smalltalk/smalltalk-$TERMUX_PKG_VERSION.tar.gz"
TERMUX_PKG_SHA256=13a7480553c182dbb8092bd4f215781b9ec871758d1db7045c2d8587e4d1bef9
TERMUX_PKG_DEPENDS="gdbm, glib, libandroid-execinfo, libandroid-support, libexpat, libffi, libgmp, libiconv, libltdl, libsigsegv, libsqlite, zlib"
TERMUX_PKG_BREAKS="smalltalk-dev"
TERMUX_PKG_REPLACES="smalltalk-dev"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="--disable-gtk"
TERMUX_PKG_HOSTBUILD=true

termux_step_host_build() {
	if [[ "$TERMUX_ON_DEVICE_BUILD" == "true" ]]; then
		return
	fi

	pushd "$TERMUX_PKG_SRCDIR"
	autoreconf -fi
	sed 's/int yylineno = 1;//g' -i libgst/genpr-scan.l
	sed 's/int yylineno = 1;//g' -i libgst/genvm-scan.l
	sed 's/int yylineno = 1;//g' -i libgst/genbc-scan.l
	popd

	# Building bloxtk on archlinux fails with this error: https://bugs.gentoo.org/582936
	"$TERMUX_PKG_SRCDIR"/configure --disable-gtk --disable-bloxtk
	make
}

termux_step_pre_configure() {
	autoreconf -fi

	# the source code is not compatible with C23, having errors like this if compiled
	# in C23 mode:
	# test.c:3:18: error: unknown type name 'argc'
	# int getopt_long (argc, argv, options, long_options, opt_index)
	# but will default to C23 (gnu23) if not forced to a lower C specification level.
	export CFLAGS+=" -std=gnu99"

	export LDFLAGS+=" -landroid-execinfo"

	if [[ "$TERMUX_ON_DEVICE_BUILD" == "false" ]]; then
		export LD_LIBRARY_PATH="$TERMUX_PKG_HOSTBUILD_DIR/libgst/.libs"
		local patch="$TERMUX_PKG_BUILDER_DIR/Makefile.am.diff"
		echo "Applying patch: $(basename "$patch")"
		sed -e "s%\@TERMUX_PKG_HOSTBUILD_DIR\@%$TERMUX_PKG_HOSTBUILD_DIR%g" \
			"$patch" | patch --silent -p1 -d "$TERMUX_PKG_SRCDIR"
	fi
}
