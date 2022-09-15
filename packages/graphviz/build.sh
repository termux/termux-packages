TERMUX_PKG_HOMEPAGE=https://www.graphviz.org/
TERMUX_PKG_DESCRIPTION="Rich set of graph drawing tools"
TERMUX_PKG_LICENSE="EPL-2.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=5.0.1
TERMUX_PKG_SRCURL=https://gitlab.com/graphviz/graphviz/-/archive/$TERMUX_PKG_VERSION/graphviz-$TERMUX_PKG_VERSION.tar.gz
TERMUX_PKG_SHA256=6c704a3ffeaf2f7ae63f7d0da453cd624d93a9306a2e5dbda07e5ec38343d2b8
TERMUX_PKG_DEPENDS="libandroid-glob, libc++, libcairo, pango, libexpat, libltdl, librsvg, libgd, zlib"
TERMUX_PKG_BREAKS="graphviz-dev"
TERMUX_PKG_REPLACES="graphviz-dev"
TERMUX_PKG_BUILD_DEPENDS="libtool"
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
--with-expatlibdir=$TERMUX_PREFIX/lib
--with-ltdl-include=$TERMUX_PREFIX/include
--with-ltdl-lib=$TERMUX_PREFIX/lib
--with-pangocairo=yes
--with-pic
--with-poppler=no
--with-x=no
"
TERMUX_PKG_FORCE_CMAKE=false
TERMUX_PKG_RM_AFTER_INSTALL="bin/*-config share/man/man1/*-config.1"

termux_step_pre_configure() {
	./autogen.sh NOCONFIG
	export HOSTCC="gcc"

	LDFLAGS+=" -lm -landroid-glob"
	LDFLAGS+=" $($CC -print-libgcc-file-name)"
	LDFLAGS+=" -Wl,-rpath=$TERMUX_PREFIX/lib/graphviz"
}

termux_step_create_debscripts() {
	echo "#!$TERMUX_PREFIX/bin/sh" > postinst
	echo "dot -c" >> postinst
	echo "exit 0" >> postinst
	chmod 0755 postinst
}
