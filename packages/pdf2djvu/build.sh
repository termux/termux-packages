TERMUX_PKG_HOMEPAGE=https://github.com/jwilk/pdf2djvu
TERMUX_PKG_DESCRIPTION="PDF to DjVu converter"
TERMUX_PKG_LICENSE="GPL-2.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=0.9.18.2
TERMUX_PKG_REVISION=4
TERMUX_PKG_SRCURL=https://github.com/jwilk/pdf2djvu/releases/download/${TERMUX_PKG_VERSION}/pdf2djvu-${TERMUX_PKG_VERSION}.tar.xz
TERMUX_PKG_SHA256=9ea03f21d841a336808d89d65015713c0785e7295a6559d77771dc795333a9fa
TERMUX_PKG_DEPENDS="djvulibre, libc++, libiconv, poppler"
TERMUX_PKG_BUILD_IN_SRC=true
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
--disable-xmp
"

termux_step_pre_configure() {
	CXXFLAGS+=" -std=c++17"
}
