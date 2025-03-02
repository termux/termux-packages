TERMUX_PKG_HOMEPAGE=https://github.com/falconindy/pkgfile
TERMUX_PKG_DESCRIPTION="An alpm .files metadata explorer"
TERMUX_PKG_LICENSE="MIT"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=24
TERMUX_PKG_SRCURL=https://github.com/falconindy/pkgfile/archive/refs/tags/v${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=b75ee054b72d374037205c6ccfe8d64f4a80267f05c1a97221003bc01d8a4ac6
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_UPDATE_TAG_TYPE="newest-tag"
TERMUX_PKG_DEPENDS="libandroid-glob, libandroid-utimes, libarchive, libcurl, pcre"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
-Dsystemd_units=false
"

termux_step_pre_configure() {
	LDFLAGS+=" -landroid-glob -landroid-utimes"
}

termux_step_create_debscripts() {
	cat <<- EOF > ./postinst
	#!$TERMUX_PREFIX/bin/sh
	mkdir -p $TERMUX_PREFIX/var/cache/pkgfile
	EOF

	cat <<- EOF > ./prerm
	#!$TERMUX_PREFIX/bin/sh
	if [ "$TERMUX_PACKAGE_FORMAT" != "pacman" ] && [ "\$1" != "remove" ]; then
	exit 0
	fi
	rm -rf $TERMUX_PREFIX/var/cache/pkgfile
	EOF
}
