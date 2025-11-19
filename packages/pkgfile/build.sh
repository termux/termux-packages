TERMUX_PKG_HOMEPAGE=https://github.com/falconindy/pkgfile
TERMUX_PKG_DESCRIPTION="An alpm .files metadata explorer"
TERMUX_PKG_LICENSE="MIT"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="25"
TERMUX_PKG_SRCURL=https://github.com/falconindy/pkgfile/archive/refs/tags/v${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=dc18d7fcb03844bfd9857cb7b05b666d8a3469a38c73d3182da05fd4f8dd6403
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
