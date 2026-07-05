TERMUX_PKG_HOMEPAGE=https://github.com/libxmp/libxmp
TERMUX_PKG_DESCRIPTION="Extended Module Player C Library that renders tracker and module music (MOD, S3M, IT, XM etc.)"
TERMUX_PKG_LICENSE="MIT"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="4.7.1"
TERMUX_PKG_SRCURL="https://github.com/libxmp/libxmp/releases/download/libxmp-${TERMUX_PKG_VERSION}/libxmp-${TERMUX_PKG_VERSION}.tar.gz"
TERMUX_PKG_SHA256=398052ddff91472e9939240422d10b92149a1f5b80d2455ff5dde129f10c28e5
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
