TERMUX_PKG_HOMEPAGE=https://github.com/termux/proot-distro
TERMUX_PKG_DESCRIPTION="Termux official utility for managing proot'ed Linux distributions"
TERMUX_PKG_LICENSE="GPL-3.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="5.1.2"
TERMUX_PKG_SRCURL=https://github.com/termux/proot-distro/archive/refs/tags/v${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=cf6d1a7ff27bcee78818716a6befedda445f0e90b047b59e4e3ed9161092d4f4
TERMUX_PKG_DEPENDS="proot (>= 5.1.107-71), python"
TERMUX_PKG_SUGGESTS="bash-completion, termux-api, zsh-completions"
TERMUX_PKG_BUILD_IN_SRC=true
TERMUX_PKG_PLATFORM_INDEPENDENT=true
TERMUX_PKG_AUTO_UPDATE=true

termux_step_pre_configure() {
	termux_setup_python_pip
}

termux_step_create_debscripts() {
	local pkgscript
	if [ "$TERMUX_PACKAGE_FORMAT" = "pacman" ]; then
		pkgscript="postupg"
	else
		pkgscript="postinst"
	fi

	cat <<- EOF > ./"$pkgscript"
	#!${TERMUX_PREFIX}/bin/bash
	set -e
	msg() {
		echo
		echo "You are upgrading proot-distro to new major release v5.x"
		echo
		echo "Information about this release can be obtained through:"
		echo
		echo "* proot-distro help"
		echo "* https://github.com/termux/proot-distro/issues/666"
		echo
	}
	EOF

	if [ "$TERMUX_PACKAGE_FORMAT" = "pacman" ]; then
		echo '[ -n "$2" ] && [ "$(vercmp "$2" "5.0.0")" -lt 0 ] && msg' >> ./"$pkgscript"
	else
		echo '[ "$1" = "configure" ] && [ -n "$2" ] && dpkg --compare-versions "$2" lt "5.0.0" && msg' >> ./"$pkgscript"
	fi
}
