TERMUX_PKG_HOMEPAGE=http://www.graphviz.org/
TERMUX_PKG_DESCRIPTION="rich set of graph drawing tools"
TERMUX_PKG_VERSION=2.38.0
TERMUX_PKG_BUILD_REVISION=1
TERMUX_PKG_SRCURL=http://www.graphviz.org/pub/graphviz/stable/SOURCES/graphviz-$TERMUX_PKG_VERSION.tar.gz
TERMUX_PKG_DEPENDS="libandroid-glob,libcairo,pango,libexpat"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="--with-poppler=no --enable-java=no --enable-perl=no --enable-swig=no --enable-sharp=no --enable-guile=no --enable-lua=no --enable-ocaml=no --enable-php=no --enable-python=no --enable-r=no --enable-ruby=no --enable-tcl=no --enable-ltdl-install --with-pic --with-x=no --with-pangocairo=yes"
TERMUX_PKG_RM_AFTER_INSTALL="bin/*-config share/man/man1/*-config.1"

termux_step_pre_configure() {
    LDFLAGS+=" -landroid-glob"
    cp -r ../src/* .
}
