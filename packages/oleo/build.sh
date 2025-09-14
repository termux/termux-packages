TERMUX_PKG_HOMEPAGE=https://www.gnu.org/software/oleo/
TERMUX_PKG_DESCRIPTION="The GNU Spreadsheet"
TERMUX_PKG_LICENSE="GPL-2.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="1.99.16"
TERMUX_PKG_REVISION=10
TERMUX_PKG_SRCURL=http://ftp.gnu.org/gnu/oleo/oleo-$TERMUX_PKG_VERSION.tar.gz
TERMUX_PKG_SHA256=6598df85d06ff2534ec08ed0657508f17dbbc58dd02d419160989de7c487bc86
TERMUX_PKG_DEPENDS="ncurses"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="--without-x --infodir=$TERMUX_PREFIX/share/info"
TERMUX_PKG_KEEP_INFOPAGES=true

TERMUX_PKG_RM_AFTER_INSTALL="
Oleo/*
share/oleo/oleo.html"

termux_step_pre_configure() {
	# configure script tries to build program which writes `sizeof` expression
	# result with our toolchain and tries to execute it which is impossible
	# with cross-compiling inside docker.
	export ac_cv_sizeof_short=__SIZEOF_SHORT__
	export ac_cv_sizeof_int=__SIZEOF_INT__
	export ac_cv_sizeof_long=__SIZEOF_LONG__
	export ac_cv_header_stdc=yes

	export CFLAGS+=" -fcommon"
}
