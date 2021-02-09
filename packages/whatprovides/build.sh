TERMUX_PKG_HOMEPAGE=https://github.com/termux/whatprovides
TERMUX_PKG_DESCRIPTION="Find out packages using specific files"
TERMUX_PKG_LICENSE="Apache-2.0"
TERMUX_PKG_MAINTAINER="Krishna kanhaiya @kcubeterm"
TERMUX_PKG_VERSION=2.2.0
TERMUX_PKG_SRCURL=https://github.com/termux/whatprovides/archive/${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=a7f41c974cdfa78d8d8c46083c2b04a03cadd6b5e1e135e08617f128b6bbb357
TERMUX_PKG_DEPENDS="bash, coreutils, curl, gawk, gzip, sqlite"
TERMUX_PKG_BUILD_IN_SRC=true
TERMUX_PKG_PLATFORM_INDEPENDENT=true

termux_step_create_debscripts() {
	cat <<- EOF > ./postinst
	#!${TERMUX_PREFIX}/bin/sh
	mkdir -p "${TERMUX_PREFIX}/var/lib/whatprovides"
	if [ ! -e "${TERMUX_PREFIX}/var/lib/whatprovides/whatprovides.db" ]; then
	whatprovides -u || {
	echo
	echo "Failed to download database."
	echo "Please run 'whatprovides -u' manually."
	echo
	}
	fi
	EOF

	cat <<- EOF > ./prerm
	#!${TERMUX_PREFIX}/bin/sh
	if [ "\$1" != "remove" ]; then
	    exit 0
	fi
	rm -rf "${TERMUX_PREFIX}/var/lib/whatprovides"
	EOF
}
