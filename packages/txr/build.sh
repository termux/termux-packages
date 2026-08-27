TERMUX_PKG_HOMEPAGE=https://www.nongnu.org/txr/
TERMUX_PKG_DESCRIPTION="Data munging language and pattern matching tool"
TERMUX_PKG_LICENSE="BSD 2-Clause"
TERMUX_PKG_MAINTAINER="Jules Amonith <examosa@fastmail.com>"
TERMUX_PKG_VERSION="302"
TERMUX_PKG_SRCURL="https://www.kylheku.com/cgit/txr/snapshot/txr-${TERMUX_PKG_VERSION}.tar.gz"
TERMUX_PKG_SHA256=94778081f698c2922117dc4bcbcc50f8c279c128660f4233221ce748d1369dc7
TERMUX_PKG_DEPENDS="libffi, zlib"
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_HOSTBUILD=true
TERMUX_PKG_EXTRA_HOSTBUILD_CONFIGURE_ARGS="ccname=gcc"
TERMUX_PKG_EXTRA_MAKE_ARGS="LN:=ln LN+=-rs"

termux_step_pre_configure() {
	cp --force --no-preserve=timestamps \
		"${TERMUX_PKG_HOSTBUILD_DIR}/stdlib/"*.tlo \
		"${TERMUX_PKG_SRCDIR}/stdlib/"
}

termux_step_configure() {
	"${TERMUX_PKG_SRCDIR}/configure" \
		prefix="${TERMUX__PREFIX}" \
		do_nopie=
}
