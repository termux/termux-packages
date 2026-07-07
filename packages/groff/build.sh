TERMUX_PKG_HOMEPAGE=https://www.gnu.org/software/groff/
TERMUX_PKG_DESCRIPTION="typesetting system that reads plain text mixed with formatting commands and produces formatted output"
TERMUX_PKG_LICENSE="GPL-3.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=1.24.1
TERMUX_PKG_SRCURL="https://mirrors.kernel.org/gnu/groff/groff-${TERMUX_PKG_VERSION}.tar.gz"
TERMUX_PKG_SHA256=74e2819795b6aff431aeac983d63a9c8968eeaba2a2eba7df8ba4c7b41e7cfd8
TERMUX_PKG_DEPENDS="libc++, mandoc, perl, uchardet"
TERMUX_PKG_BUILD_DEPENDS="ghostscript"
TERMUX_PKG_SUGGESTS="ghostscript"
TERMUX_PKG_GROUPS="base-devel"
TERMUX_PKG_BUILD_IN_SRC=true
TERMUX_PKG_HOSTBUILD=true
TERMUX_PKG_EXTRA_HOSTBUILD_CONFIGURE_ARGS="
	am_cv_func_iconv=no
	--enable-year2038
	--with-urw-fonts-dir=$TERMUX_PREFIX/share/ghostscript/Resource/Font
	--without-x
"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
	$TERMUX_PKG_EXTRA_HOSTBUILD_CONFIGURE_ARGS
	--with-uchardet
"
TERMUX_PKG_RM_AFTER_INSTALL="
bin/soelim
share/man/man1/soelim.1*
share/man/man7/roff.7*
"

termux_step_pre_configure() {
	# URW fonts are currently not building in cross-builds as of 1.24.1,
	# the exact mechanism of this breakage isn't clear to me.
	# Upstream mailing list message:
	# https://lists.gnu.org/archive/html/groff/2026-07/msg00042.html
	# Upstream bug report:
	# https://savannah.gnu.org/bugs/?68564
	#
	# Manually copying them to the expected location in the TERMUX_PKG_SRCDIR
	# works as a hack to satisfy the `make install-devpdffontDATA` target.
	install -vDm600 "$TERMUX_PKG_HOSTBUILD_DIR/font/devpdf"/U-* \
		"$TERMUX_PKG_SRCDIR/font/devpdf/"

	# Point the build at the host-built `groff` to use for the cross-build.
	sed -i "s|@abs_top_builddir@|${TERMUX_TOPDIR}/groff/host-build|" Makefile.in
}
