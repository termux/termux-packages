TERMUX_PKG_HOMEPAGE=https://mate-desktop.org
TERMUX_PKG_DESCRIPTION="MATE document viewer"
TERMUX_PKG_LICENSE="GPL-2.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="1.28.0"
TERMUX_PKG_SRCURL=https://pub.mate-desktop.org/releases/${TERMUX_PKG_VERSION%.*}/atril-${TERMUX_PKG_VERSION}.tar.xz
TERMUX_PKG_SHA256=ced4725f6e9b71c4ea63676bfc3cc3be09d29dba08aa7a7ab97964e0b4355162
TERMUX_PKG_AUTO_UPDATE=true
# links with poppler-glib, not poppler
TERMUX_PKG_DEPENDS="atk, djvulibre, gdk-pixbuf, glib, gtk3, harfbuzz, libarchive, libc++, libcairo, libice, libsecret, libsm, libsoup3, libtiff, libxml2, mate-desktop, pango, poppler, texlive-bin, webkit2gtk-4.1, zlib"
TERMUX_PKG_BUILD_DEPENDS="g-ir-scanner, glib-cross"
TERMUX_PKG_DISABLE_GIR=false
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
--disable-caja
--enable-djvu
--enable-dvi
--enable-epub
--enable-introspection
--enable-pixbuf
"

termux_step_pre_configure() {
	TERMUX_PKG_VERSION=. termux_setup_gir

	CPPFLAGS+=" -DHAVE_MEMCPY -Wno-deprecated-declarations"

	# fix arm build and potentially other archs hidden bugs
	# ERROR: ./lib/atril/3/backends/libpdfdocument.so contains undefined symbols:
	# 162: 00000000     0 NOTYPE  GLOBAL DEFAULT   UND __aeabi_idivmod
	# 163: 00000000     0 NOTYPE  GLOBAL DEFAULT   UND __aeabi_idiv
	LDFLAGS+=" $($CC -print-libgcc-file-name)"
}
