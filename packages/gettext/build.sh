TERMUX_PKG_HOMEPAGE=https://www.gnu.org/software/gettext/
TERMUX_PKG_DESCRIPTION="GNU Internationalization utilities"
TERMUX_PKG_LICENSE="GPL-3.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="0.24"
TERMUX_PKG_REVISION=1
TERMUX_PKG_SRCURL=https://mirrors.kernel.org/gnu/gettext/gettext-${TERMUX_PKG_VERSION}.tar.xz
TERMUX_PKG_SHA256=e1620d518b26d7d3b16ac570e5018206e8b0d725fb65c02d048397718b5cf318
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_DEPENDS="libc++, libiconv, libunistring, libxml2, ncurses"
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
