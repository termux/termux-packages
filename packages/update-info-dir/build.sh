TERMUX_PKG_HOMEPAGE=https://packages.debian.org/sid/texinfo
TERMUX_PKG_DESCRIPTION="Update or create index file from all installed info files in directory"
TERMUX_PKG_LICENSE="GPL-2.0, GPL-3.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=6.8-6
TERMUX_PKG_SRCURL=https://deb.debian.org/debian/pool/main/t/texinfo/texinfo_${TERMUX_PKG_VERSION}.debian.tar.xz
TERMUX_PKG_SHA256=1399525b5c61cdd10a525370975f11d8dc61e9ea54616beed212fe8e98846894
TERMUX_PKG_PLATFORM_INDEPENDENT=true
TERMUX_PKG_BUILD_IN_SRC=true

termux_step_make_install() {
	install -Dm700 -t $TERMUX_PREFIX/bin update-info-dir
	install -Dm600 -t $TERMUX_PREFIX/share/man/man8 update-info-dir.8
}

termux_step_create_debscripts() {
	local INFODIR=$TERMUX_PREFIX/share/info

	cat <<- EOF > ./triggers
	interest-noawait $INFODIR
	EOF

	cat <<- EOF > ./postinst
	#!$TERMUX_PREFIX/bin/sh
	if [ -d $INFODIR ]; then
	    $TERMUX_PREFIX/bin/update-info-dir
	fi
	exit 0
	EOF

	cat <<- EOF > ./prerm
	#!$TERMUX_PREFIX/bin/sh
	rm -rf $INFODIR/dir
	exit 0
	EOF
}
