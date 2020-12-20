TERMUX_PKG_HOMEPAGE=https://freeimage.sourceforge.io
TERMUX_PKG_DESCRIPTION="The library project for developers who would like to support popular graphics image formats."
TERMUX_PKG_LICENSE="custom"
TERMUX_PKG_LICENSE_FILE="license-fi.txt, license-gplv2.txt, license-gplv3.txt, license-bsd-2-clause.txt"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=3.18.0
TERMUX_PKG_SRCURL=https://downloads.sourceforge.net/project/freeimage/Source%20Distribution/${TERMUX_PKG_VERSION}/FreeImage${TERMUX_PKG_VERSION//./}.zip
TERMUX_PKG_SHA256=f41379682f9ada94ea7b34fe86bf9ee00935a3147be41b6569c9605a53e438fd
TERMUX_PKG_BUILD_IN_SRC=true
TERMUX_PKG_EXTRA_MAKE_ARGS="DESTDIR=${TERMUX_PREFIX}/../"
TERMUX_PKG_MAKE_INSTALL_TARGET="DESTDIR=${TERMUX_PREFIX}/../ install"

termux_step_pre_configure() {
	cp -f $TERMUX_PKG_BUILDER_DIR/license-bsd-2-clause.txt $TERMUX_PKG_SRCDIR/
}
