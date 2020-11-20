TERMUX_PKG_HOMEPAGE=https://github.com/termux/whatprovides
TERMUX_PKG_DESCRIPTION="Whatprovides utility for termux"
TERMUX_PKG_LICENSE="Apache-2.0"
TERMUX_PKG_MAINTAINER="Krishna kanhaiya @kcubeterm"
TERMUX_PKG_VERSION=1.1.0
TERMUX_PKG_SRCURL=https://github.com/termux/whatprovides/archive/${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=ad1b76e67278a05c997ad5abbdb58ee47d406b203a5dc95b2b8e673d385e8386
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
