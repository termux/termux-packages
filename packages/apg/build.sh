## Note: APG project seems dead. Official homepage & src urls
## disappeared.

TERMUX_PKG_HOMEPAGE=http://www.adel.nursat.kz/apg/index.shtml
TERMUX_PKG_DESCRIPTION="Automated Password Generator"
TERMUX_PKG_LICENSE="BSD"
TERMUX_PKG_VERSION=2.3.0b
TERMUX_PKG_REVISION=4
TERMUX_PKG_SRCURL=https://dl.bintray.com/termux/upstream/apg-2.3.0b.tar.gz
TERMUX_PKG_SHA256=d1e52029709e2d7f9cb99bedce3e02ee7a63cff7b8e2b4c2bc55b3dc03c28b92
TERMUX_PKG_DEPENDS="libcrypt"
TERMUX_PKG_BUILD_IN_SRC=true

termux_step_post_extract_package() {
	# Fix permissions.
	find "$TERMUX_PKG_SRCDIR" -type d -exec chmod 700 "{}" \;
	find "$TERMUX_PKG_SRCDIR" -type f -executable -exec chmod 700 "{}" \;
	find "$TERMUX_PKG_SRCDIR" -type f ! -executable -exec chmod 600 "{}" \;
}
