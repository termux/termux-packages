TERMUX_PKG_HOMEPAGE=https://www.graphviz.org/
TERMUX_PKG_DESCRIPTION="Rich set of graph drawing tools"
TERMUX_PKG_LICENSE="EPL-2.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=2.50.0
TERMUX_PKG_SRCURL=https://gitlab.com/graphviz/graphviz/-/archive/$TERMUX_PKG_VERSION/graphviz-$TERMUX_PKG_VERSION.tar.gz
TERMUX_PKG_SHA256=afa48581f764a35e148909cc96a0308ec2356b5225b64af12492f3392f20ef1c
TERMUX_PKG_DEPENDS="libandroid-glob, libc++, libcairo, pango, libexpat, libltdl, librsvg, libgd, zlib"
TERMUX_PKG_BREAKS="graphviz-dev"
TERMUX_PKG_REPLACES="graphviz-dev"
TERMUX_PKG_BUILD_DEPENDS="libtool"
TERMUX_PKG_FORCE_CMAKE=true
TERMUX_PKG_RM_AFTER_INSTALL="bin/*-config share/man/man1/*-config.1"

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
