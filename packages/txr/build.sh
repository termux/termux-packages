TERMUX_PKG_HOMEPAGE=https://www.nongnu.org/txr/
TERMUX_PKG_DESCRIPTION="Data munging language and pattern matching tool"
TERMUX_PKG_LICENSE="BSD 2-Clause"
TERMUX_PKG_MAINTAINER="@examosa"
TERMUX_PKG_VERSION="302"
TERMUX_PKG_SRCURL=(
	https://www.kylheku.com/cgit/txr/snapshot/txr-${TERMUX_PKG_VERSION}.tar.gz
	https://www.kylheku.com/txr-downloads/txr-${TERMUX_PKG_VERSION}/txr-${TERMUX_PKG_VERSION}-Android-13.tar.gz
)
TERMUX_PKG_SHA256=(
	94778081f698c2922117dc4bcbcc50f8c279c128660f4233221ce748d1369dc7
	23f4ead9d0021a6f328d89c6d1e6072595039d40cdf137bed577955a63234ca0
)
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_DEPENDS="libffi, zlib"
TERMUX_PKG_EXTRA_MAKE_ARGS="LN:=ln LN+=-rs"

termux_step_post_get_source() {
    cp "${TERMUX_PKG_SRCDIR}/data/data/com.termux/files/usr/share/txr/stdlib/"*.tlo "${TERMUX_PKG_SRCDIR}/stdlib/"
    touch "${TERMUX_PKG_SRCDIR}/stdlib/"*.tlo
}

termux_step_configure() {
	"${TERMUX_PKG_SRCDIR}/configure" \
		prefix="${TERMUX__PREFIX}" \
		do_nopie=
}
