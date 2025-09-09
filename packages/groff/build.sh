TERMUX_PKG_HOMEPAGE=https://www.gnu.org/software/groff/
TERMUX_PKG_DESCRIPTION="typesetting system that reads plain text mixed with formatting commands and produces formatted output"
TERMUX_PKG_LICENSE="GPL-3.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=1.23.0
TERMUX_PKG_REVISION=2
TERMUX_PKG_SRCURL=https://mirrors.kernel.org/gnu/groff/groff-${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=6b9757f592b7518b4902eb6af7e54570bdccba37a871fddb2d30ae3863511c13
TERMUX_PKG_DEPENDS="libc++, perl, mandoc"
TERMUX_PKG_GROUPS="base-devel"
TERMUX_PKG_BUILD_IN_SRC=true
TERMUX_PKG_HOSTBUILD=true
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
am_cv_func_iconv=no
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
	install -Dm600 $TERMUX_PKG_HOSTBUILD_DIR/font/devpdf/[A-CEG-Z]* \
		$TERMUX_PREFIX/share/groff/current/font/devpdf/
}
