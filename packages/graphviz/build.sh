TERMUX_PKG_HOMEPAGE=https://www.graphviz.org/
TERMUX_PKG_DESCRIPTION="Rich set of graph drawing tools"
TERMUX_PKG_LICENSE="EPL-2.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=2.49.3
TERMUX_PKG_SRCURL=https://gitlab.com/graphviz/graphviz/-/archive/${TERMUX_PKG_VERSION}/graphviz-${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=5801664769ab88c2fb8ccb6ab0957cceabe6d4632b193041440e97790f53a9df
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
--with-ltdl-include=$TERMUX_PREFIX/include
--with-ltdl-lib=$TERMUX_PREFIX/lib
--with-pangocairo=yes
--with-pic
--with-poppler=no
--with-x=no
"
TERMUX_PKG_RM_AFTER_INSTALL="bin/*-config share/man/man1/*-config.1"

# In file included from /home/builder/.termux-build/graphviz/src/lib/expr/expr.h:28:
# /home/builder/.termux-build/graphviz/src/lib/expr/exparse.h:4:10: fatal error: 'expr/y.tab.h' file not found
TERMUX_PKG_BUILD_IN_SRC=true

termux_step_pre_configure() {
	./autogen.sh NOCONFIG
	export HOSTCC="gcc"
}

termux_step_post_make_install() {
	# Some binaries (dot_builtins, gvpack) links against these:
	cd $TERMUX_PREFIX/lib
	for lib in graphviz/*.so*; do
		ln -s -f $lib $(basename $lib)
	done
}

termux_step_create_debscripts() {
	echo "#!$TERMUX_PREFIX/bin/sh" > postinst
	echo "dot -c" >> postinst
	echo "exit 0" >> postinst
	chmod 0755 postinst
}
