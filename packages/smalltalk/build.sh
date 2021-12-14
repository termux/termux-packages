TERMUX_PKG_HOMEPAGE=http://smalltalk.gnu.org/
TERMUX_PKG_DESCRIPTION="A free implementation of the Smalltalk-80 language"
TERMUX_PKG_LICENSE="GPL-2.0, LGPL-2.1"
TERMUX_PKG_MAINTAINER="Henrik Grimler @Grimler91"
TERMUX_PKG_VERSION=3.2.91
TERMUX_PKG_REVISION=14
TERMUX_PKG_SRCURL=ftp://alpha.gnu.org/gnu/smalltalk/smalltalk-$TERMUX_PKG_VERSION.tar.gz
TERMUX_PKG_SHA256=13a7480553c182dbb8092bd4f215781b9ec871758d1db7045c2d8587e4d1bef9
TERMUX_PKG_DEPENDS="glib, libandroid-support, libffi, libltdl, libsigsegv, zlib"
TERMUX_PKG_BREAKS="smalltalk-dev"
TERMUX_PKG_REPLACES="smalltalk-dev"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="--disable-gtk"
TERMUX_PKG_HOSTBUILD=true

termux_step_host_build() {
	(cd "$TERMUX_PKG_SRCDIR"
		autoreconf -i
		sed 's/int yylineno = 1;//g' -i libgst/genpr-scan.l
		sed 's/int yylineno = 1;//g' -i libgst/genvm-scan.l
		sed 's/int yylineno = 1;//g' -i libgst/genbc-scan.l
	)

	# Building bloxtk on archlinux fails with this error: https://bugs.gentoo.org/582936
	"$TERMUX_PKG_SRCDIR"/configure --disable-gtk --disable-bloxtk
	make
}

termux_step_pre_configure() {
	export LD_LIBRARY_PATH="$TERMUX_PKG_HOSTBUILD_DIR/libgst/.libs"
	sed -i \
		"s%@TERMUX_PKG_HOSTBUILD_DIR@%$TERMUX_PKG_HOSTBUILD_DIR%g" \
		"$TERMUX_PKG_SRCDIR"/Makefile.in
}
