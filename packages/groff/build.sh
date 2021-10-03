TERMUX_PKG_HOMEPAGE=https://www.gnu.org/software/groff/
TERMUX_PKG_DESCRIPTION="typesetting system that reads plain text mixed with formatting commands and produces formatted output"
TERMUX_PKG_LICENSE="GPL-3.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=1.22.4
TERMUX_PKG_REVISION=1
TERMUX_PKG_SRCURL=https://ftp.gnu.org/gnu/groff/groff-${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=e78e7b4cb7dec310849004fa88847c44701e8d133b5d4c13057d876c1bad0293
TERMUX_PKG_DEPENDS="perl, man"
TERMUX_PKG_GROUPS="base-devel"
TERMUX_PKG_BUILD_IN_SRC=true
TERMUX_PKG_HOSTBUILD=true

TERMUX_PKG_RM_AFTER_INSTALL="
bin/soelim
share/man/man1/soelim.1*
share/man/man7/roff.7*
"

termux_step_pre_configure() {
	sed -i "s|@abs_top_builddir@|${TERMUX_TOPDIR}/groff/host-build|" Makefile.in
}
