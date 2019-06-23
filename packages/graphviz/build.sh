TERMUX_PKG_HOMEPAGE=https://www.graphviz.org/
TERMUX_PKG_DESCRIPTION="Rich set of graph drawing tools"
TERMUX_PKG_LICENSE="EPL-2.0"
TERMUX_PKG_MAINTAINER="Dustin DeWeese @HackerFoo"
TERMUX_PKG_VERSION=2.40.1
TERMUX_PKG_REVISION=8
TERMUX_PKG_SRCURL=https://fossies.org/linux/misc/graphviz-$TERMUX_PKG_VERSION.tar.gz
TERMUX_PKG_SHA256=ca5218fade0204d59947126c38439f432853543b0818d9d728c589dfe7f3a421
TERMUX_PKG_DEPENDS="libandroid-glob, libc++, libcairo, pango, libexpat, libltdl, librsvg, libgd, zlib"
TERMUX_PKG_BUILD_DEPENDS="libtool"
TERMUX_PKG_BUILD_IN_SRC=yes
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
--enable-guile=no
--enable-java=no
--enable-lua=no
--enable-ocaml=no
--enable-perl=no
--enable-php=no
--enable-python=no
--enable-r=no
--enable-ruby=no
--enable-sharp=no
--enable-swig=no
--enable-tcl=no
--with-ltdl-include=$TERMUX_PREFIX/include
--with-ltdl-lib=$TERMUX_PREFIX/lib
--with-pangocairo=yes
--with-pic
--with-poppler=no
--with-x=no
"
TERMUX_PKG_RM_AFTER_INSTALL="bin/*-config share/man/man1/*-config.1"

termux_step_pre_configure() {
	LDFLAGS+=" -landroid-glob"
	CPPFLAGS+=" -D_typ_ssize_t=1"
}

termux_step_post_make_install() {
	# Some binaries (dot_builtins, gvpack) links against these:
	cd $TERMUX_PREFIX/lib
	for lib in graphviz/*.so.*; do
		ln -s -f $lib $(basename $lib)
	done
}

termux_step_create_debscripts() {
	echo "#!$TERMUX_PREFIX/bin/sh" > postinst
	echo "dot -c" >> postinst
	echo "exit 0" >> postinst
	chmod 0755 postinst
}
