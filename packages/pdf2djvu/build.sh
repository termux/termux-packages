TERMUX_PKG_HOMEPAGE=https://github.com/jwilk/pdf2djvu
TERMUX_PKG_DESCRIPTION="PDF to DjVu converter"
TERMUX_PKG_LICENSE="GPL-2.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=0.9.19
TERMUX_PKG_REVISION=1
TERMUX_PKG_SRCURL=https://github.com/jwilk/pdf2djvu/releases/download/${TERMUX_PKG_VERSION}/pdf2djvu-${TERMUX_PKG_VERSION}.tar.xz
TERMUX_PKG_SHA256=eb45a480131594079f7fe84df30e4a5d0686f7a8049dc7084eebe22acc37aa9a
TERMUX_PKG_DEPENDS="djvulibre, libc++, libiconv, poppler"
TERMUX_PKG_BUILD_IN_SRC=true
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
--disable-xmp
"

termux_step_pre_configure() {
	CXXFLAGS+=" -std=c++17"
}
