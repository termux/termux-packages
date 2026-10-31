TERMUX_PKG_HOMEPAGE=https://github.com/xmlstarlet/xmlstarlet
TERMUX_PKG_DESCRIPTION="Command line XML toolkit"
TERMUX_PKG_LICENSE="MIT"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=1.7.0
TERMUX_PKG_SRCURL=https://github.com/xmlstarlet/xmlstarlet/releases/download/${TERMUX_PKG_VERSION}/xmlstarlet-${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=df4c93458fc6b2ad144d65dccf3ef251349871e0578c5bc59edbfeecf9bf3454
TERMUX_PKG_DEPENDS="libxslt, libxml2"
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="--with-libxml-include-prefix=${TERMUX_PREFIX}/include/libxml2"
TERMUX_PKG_BUILD_IN_SRC=true

termux_step_post_make_install() {
	ln -sfr $TERMUX_PREFIX/bin/xml $TERMUX_PREFIX/bin/xmlstarlet
}
