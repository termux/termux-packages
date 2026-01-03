TERMUX_PKG_HOMEPAGE=https://beyondgrep.com/
TERMUX_PKG_DESCRIPTION="Tool like grep optimized for programmers"
TERMUX_PKG_LICENSE="Artistic-License-2.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=(3.9.0
					1.18)
TERMUX_PKG_REVISION=1
TERMUX_PKG_SRCURL=("https://github.com/beyondgrep/ack3/archive/refs/tags/v${TERMUX_PKG_VERSION[0]}.tar.gz"
					"https://github.com/petdance/file-next/archive/refs/tags/${TERMUX_PKG_VERSION[1]}.tar.gz")
TERMUX_PKG_SHA256=(b2233b9f30b7099db2bad9d6b7e7f7e1003a73ce24353b92b8e904d5b44fedf7
					e3c56f0bdcb3251a2e22b9ffc3c7cbf99b1433a45fc8a07f8e2e66174bc3963f)
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_UPDATE_TAG_TYPE="newest-tag"
TERMUX_PKG_DEPENDS="perl"
TERMUX_PKG_BUILD_IN_SRC=true
TERMUX_PKG_PLATFORM_INDEPENDENT=true

termux_step_pre_configure() {
	# build and install build dependency petdance/file-next
	pushd "file-next-${TERMUX_PKG_VERSION[1]}"
	perl Makefile.PL PREFIX="$TERMUX_PKG_TMPDIR"
	make
	make install
	popd
	export PERL5LIB="$TERMUX_PKG_TMPDIR/share/perl"
}

termux_step_configure() {
	perl Makefile.PL
}

termux_step_make() {
	make ack-standalone
}

termux_step_make_install() {
	install -Dm755 ack-standalone "$TERMUX_PREFIX/bin/ack"
}
