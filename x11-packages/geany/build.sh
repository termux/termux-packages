TERMUX_PKG_HOMEPAGE=https://www.geany.org/
TERMUX_PKG_DESCRIPTION="Fast and lightweight IDE"
TERMUX_PKG_LICENSE="GPL-2.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="2.1"
TERMUX_PKG_SRCURL=https://download.geany.org/geany-${TERMUX_PKG_VERSION}.tar.bz2
TERMUX_PKG_SHA256=6b96a8844463300c10b9692a0a5edad8236eec9e84342f575f83d4fc89331228
TERMUX_PKG_AUTO_UPDATE=true
# libvte is dlopen(3)ed:
TERMUX_PKG_DEPENDS="atk, gdk-pixbuf, glib, gtk3, harfbuzz, libandroid-glob, libc++, libcairo, libvte, pango"
TERMUX_PKG_RECOMMENDS="clang, make"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="--enable-gtk3 --enable-vte"

TERMUX_PKG_RM_AFTER_INSTALL="
share/icons/Tango/icon-theme.cache
"

termux_step_pre_configure() {
	export LIBS="-landroid-glob"

	# error: non-exported symbol '__aarch64_ldadd4_acq_rel' in libclang_rt.builtins-aarch64-android.a
	local _libgcc_file="$($CC -print-libgcc-file-name)"
	local _libgcc_path="$(dirname $_libgcc_file)"
	local _libgcc_name="$(basename $_libgcc_file)"
	LDFLAGS+=" -L$_libgcc_path -l:$_libgcc_name"
}
