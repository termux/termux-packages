TERMUX_PKG_HOMEPAGE=https://www.gnu.org/software/groff/
TERMUX_PKG_DESCRIPTION="typesetting system that reads plain text mixed with formatting commands and produces formatted output"
TERMUX_PKG_LICENSE="GPL-3.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=1.24.1
TERMUX_PKG_SRCURL="https://mirrors.kernel.org/gnu/groff/groff-${TERMUX_PKG_VERSION}.tar.gz"
TERMUX_PKG_SHA256=74e2819795b6aff431aeac983d63a9c8968eeaba2a2eba7df8ba4c7b41e7cfd8
TERMUX_PKG_DEPENDS="libc++, mandoc, perl, uchardet"
TERMUX_PKG_BUILD_DEPENDS="ghostscript"
TERMUX_PKG_BUILD_SUGGESTS="ghostscript"
TERMUX_PKG_GROUPS="base-devel"
TERMUX_PKG_BUILD_IN_SRC=true
TERMUX_PKG_HOSTBUILD=true
TERMUX_PKG_EXTRA_HOSTBUILD_CONFIGURE_ARGS="
	am_cv_func_iconv=no
	--enable-year2038
	--without-x
"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
	$TERMUX_PKG_EXTRA_HOSTBUILD_CONFIGURE_ARGS
	--with-urw-fonts-dir=$TERMUX_PREFIX/share/ghostscript/Resource/Font
	--with-uchardet
"
TERMUX_PKG_RM_AFTER_INSTALL="
bin/soelim
share/man/man1/soelim.1*
share/man/man7/roff.7*
"

termux_step_pre_configure() {
	sed -i "s|@abs_top_builddir@|${TERMUX_TOPDIR}/groff/host-build|" Makefile.in
}

termux_step_post_make_install() {
	# All except DESC and Foundry
	install -vDm600 "$TERMUX_PKG_HOSTBUILD_DIR/font/devpdf"/[A-CEG-Z]* \
		"$TERMUX_PREFIX/share/groff/current/font/devpdf/"
}
