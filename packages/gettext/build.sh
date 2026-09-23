TERMUX_PKG_HOMEPAGE=https://www.gnu.org/software/gettext/
TERMUX_PKG_DESCRIPTION="GNU Internationalization utilities"
TERMUX_PKG_LICENSE="GPL-3.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="1.0"
TERMUX_PKG_SRCURL=https://mirrors.kernel.org/gnu/gettext/gettext-${TERMUX_PKG_VERSION}.tar.xz
TERMUX_PKG_SHA256=71132a3fb71e68245b8f2ac4e9e97137d3e5c02f415636eb508ae607bc01add7
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_DEPENDS="attr, libc++, libiconv, libunistring, libxml2, ncurses"
TERMUX_PKG_BREAKS="gettext-dev"
TERMUX_PKG_REPLACES="gettext-dev"
TERMUX_PKG_BUILD_IN_SRC=true
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
ac_cv_have_decl_posix_spawn=no
ac_cv_header_spawn_h=no
gl_cv_func_working_error=yes
gl_cv_terminfo_tparm=yes
--disable-openmp
--with-included-libcroco
--with-included-libglib
--without-included-libxml
--with-included-libintl
"
TERMUX_PKG_GROUPS="base-devel"

termux_step_pre_configure() {
	if [ $TERMUX_ARCH_BITS = 32 ]; then
		LDFLAGS+=" -Wl,-z,muldefs"
	fi
}

termux_step_post_configure() {
	local pv=$(awk '/^PACKAGE_VERSION =/ { print $3 }' Makefile)
	local lib
	for lib in libgettext{lib,src}; do
		ln -sf ${lib}-${pv}.so $TERMUX_PREFIX/lib/${lib}.so
	done
}

# Android/bionic has no gettext() implementation in its C library, and the
# header Termux ships today (ndk-patches/libintl.h) declares every gettext
# function as a `static __inline__` no-op returning the untranslated msgid.
# Consequently no package can ever display a translation, and there is no
# `libintl.so` anywhere in the repository to link against.
#
# Ship the real GNU libintl built here. Two deliberate choices:
#
# 1. The header goes to $TERMUX_PREFIX/include/gettext-libintl/ and NOT to
#    $TERMUX_PREFIX/include/libintl.h, which is owned by the `ndk-sysroot`
#    package: overwriting it would make every other package in the repository
#    fail to link, since a large number of them call gettext() without linking
#    any library and rely on the inline stub for that.
#    Packages that want real translations add
#    `-I$TERMUX_PREFIX/include/gettext-libintl` and link `-lintl`.
#
# 2. libintl.so is installed unconditionally rather than trusting the
#    `make install` of gettext-runtime, whose libintl install rules are
#    conditional (`@USE_INCLUDED_LIBINTL_TRUE@`) and therefore easy to lose
#    when the configure results change.
termux_step_post_make_install() {
	local intl_dir="$TERMUX_PKG_SRCDIR/gettext-runtime/intl"
	local dest="$TERMUX_PREFIX/include/gettext-libintl"

	if [ ! -f "$intl_dir/.libs/libintl.so" ]; then
		termux_error_exit "libintl.so was not built: $intl_dir/.libs/libintl.so is missing"
	fi

	# Real header (never the Bionic stub from ndk-patches).
	install -d "$dest"
	install -m 644 "$intl_dir/libintl.h" "$dest/libintl.h"

	# Real library, plus the .a and .la used by other packages at build time.
	install -m 755 "$intl_dir/.libs/libintl.so" "$TERMUX_PREFIX/lib/libintl.so"
	if [ -f "$intl_dir/.libs/libintl.a" ]; then
		install -m 644 "$intl_dir/.libs/libintl.a" "$TERMUX_PREFIX/lib/libintl.a"
	fi
	if [ -f "$intl_dir/libintl.la" ]; then
		install -m 644 "$intl_dir/libintl.la" "$TERMUX_PREFIX/lib/libintl.la"
	fi
}
