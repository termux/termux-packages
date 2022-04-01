TERMUX_PKG_HOMEPAGE=https://www.gnu.org/software/hello/
TERMUX_PKG_DESCRIPTION="Prints a friendly greeting"
TERMUX_PKG_LICENSE="GPL-3.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=2.12
TERMUX_PKG_SRCURL=https://ftp.gnu.org/gnu/hello/hello-${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=cf04af86dc085268c5f4470fbae49b18afbc221b78096aab842d934a76bad0ab
TERMUX_PKG_DEPENDS="libiconv"
TERMUX_PKG_BUILD_IN_SRC=true

termux_step_pre_configure() {
	LDFLAGS+=" -liconv"
}
