TERMUX_PKG_HOMEPAGE=https://github.com/libxmp/libxmp
TERMUX_PKG_DESCRIPTION="Extended Module Player C Library that renders tracker and module music (MOD, S3M, IT, XM etc.)"
TERMUX_PKG_LICENSE="MIT"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="4.7.0"
TERMUX_PKG_SRCURL="https://github.com/libxmp/libxmp/releases/download/libxmp-${TERMUX_PKG_VERSION}/libxmp-${TERMUX_PKG_VERSION}.tar.gz"
TERMUX_PKG_SHA256=b6251de1859352c6988752563d60983cb8aa9fd7dfe9f81b8bc6688da47f3464
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_FORCE_CMAKE=true

TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
-DBUILD_SHARED=ON
-DBUILD_STATIC=ON
-DLIBM_REQUIRED=ON
-DLIBM_LIBRARY=m
"

termux_step_pre_configure() {
	# Extract license from README and save it to a new LICENSE file
	sed -n '/^LICENSE$/,/^THE SOFTWARE\.$/p' README > "$TERMUX_PKG_SRCDIR/LICENSE"
}
