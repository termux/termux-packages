TERMUX_PKG_HOMEPAGE=https://mate-desktop.org
TERMUX_PKG_DESCRIPTION="MATE document viewer"
TERMUX_PKG_LICENSE="GPL-2.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="1.28.1"
TERMUX_PKG_REVISION=4
TERMUX_PKG_SRCURL="https://pub.mate-desktop.org/releases/${TERMUX_PKG_VERSION%.*}/atril-${TERMUX_PKG_VERSION}.tar.xz"
TERMUX_PKG_SHA256=74c4f42979f3ead52def23767448d06ad7f715421e03c9b509404b096de8193e
TERMUX_PKG_AUTO_UPDATE=true
# links with poppler-glib, not poppler
TERMUX_PKG_DEPENDS="atk, djvulibre, gdk-pixbuf, glib, gtk3, harfbuzz, libarchive, libc++, libcairo, libice, libsecret, libsm, libsoup3, libtiff, libxml2, mate-desktop, pango, poppler, texlive-bin, webkit2gtk-4.1, zlib"
TERMUX_PKG_BUILD_DEPENDS="g-ir-scanner, glib-cross"
TERMUX_PKG_VERSIONED_GIR=false
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
	termux_setup_gir

	CPPFLAGS+=" -DHAVE_MEMCPY -Wno-deprecated-declarations"

	# fix arm build and potentially other archs hidden bugs
	# ERROR: ./lib/atril/3/backends/libpdfdocument.so contains undefined symbols:
	# 162: 00000000     0 NOTYPE  GLOBAL DEFAULT   UND __aeabi_idivmod
	# 163: 00000000     0 NOTYPE  GLOBAL DEFAULT   UND __aeabi_idiv
	local _libgcc_file="$($CC -print-libgcc-file-name)"
	local _libgcc_path="$(dirname $_libgcc_file)"
	local _libgcc_name="$(basename $_libgcc_file)"
	LDFLAGS+=" -L$_libgcc_path -l:$_libgcc_name"
}
