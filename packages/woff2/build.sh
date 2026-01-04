TERMUX_PKG_HOMEPAGE=https://www.w3.org/TR/WOFF2/
TERMUX_PKG_DESCRIPTION="font compression reference code"
TERMUX_PKG_LICENSE="MIT"
TERMUX_PKG_MAINTAINER="@termux"
# Revdep rebuild may be required with every version bump.
TERMUX_PKG_VERSION=1.0.2
TERMUX_PKG_REVISION=4
TERMUX_PKG_SRCURL=https://github.com/google/woff2/archive/refs/tags/v${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=add272bb09e6384a4833ffca4896350fdb16e0ca22df68c0384773c67a175594
# SOVERSION is equal to VERSION. Do not enable auto-update.
TERMUX_PKG_AUTO_UPDATE=false
TERMUX_PKG_DEPENDS="brotli, libc++"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
-DCMAKE_POLICY_VERSION_MINIMUM=3.5
"

termux_step_post_make_install() {
	install -Dm700 -t $TERMUX_PREFIX/bin woff2_{compress,decompress,info}
}
