TERMUX_PKG_HOMEPAGE=http://djvu.sourceforge.net/
TERMUX_PKG_DESCRIPTION="Suite to create, manipulate and view DjVu ('déjà vu') documents"
TERMUX_PKG_LICENSE="GPL-2.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=3.5.28
TERMUX_PKG_SRCURL=http://downloads.sourceforge.net/djvu/djvulibre-${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=82e392a9cccfee94fa604126c67f06dbc43ed5f9f0905d15b6c8164f83ed5655
TERMUX_PKG_DEPENDS="libtiff"

termux_step_pre_configure() {
	NOCONFIGURE=1 ./autogen.sh
}