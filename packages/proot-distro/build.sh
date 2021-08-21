TERMUX_PKG_HOMEPAGE=https://github.com/termux/proot-distro
TERMUX_PKG_DESCRIPTION="Termux official utility for managing proot'ed Linux distributions"
TERMUX_PKG_LICENSE="GPL-3.0"
TERMUX_PKG_MAINTAINER="Leonid Pliushch <leonid.pliushch@gmail.com>"
TERMUX_PKG_VERSION=2.3.1
TERMUX_PKG_SRCURL=https://github.com/termux/proot-distro/archive/v${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=a8b43897ab9553b6e36bc9c8f554b3357b98b1758293ac8a9f0686d303cb8434
TERMUX_PKG_DEPENDS="bash, bzip2, coreutils, curl, findutils, gzip, ncurses-utils, proot (>= 5.1.107-32), sed, tar, xz-utils"
TERMUX_PKG_BUILD_IN_SRC=true
TERMUX_PKG_PLATFORM_INDEPENDENT=true

termux_step_make_install() {
	TERMUX_PREFIX="$TERMUX_PREFIX" TERMUX_ANDROID_HOME="$TERMUX_ANDROID_HOME" ./install.sh
}

termux_step_create_debscripts() {
	cat <<- EOF > ./preinst
	#!${TERMUX_PREFIX}/bin/bash
	set -e
	shopt -s nullglob

	for i in ${TERMUX_PREFIX}/etc/proot-distro/*.sh; do
	  if ! grep -qP "^\s*TARBALL_URL" "\$i"; then
	    echo "Disabling old style v1.x proot-distro plug-in: \$(basename "\$i")"
	    mv -f "\${i}" "\${i}.bak"
	  fi
	done

	exit 0
	EOF
}
