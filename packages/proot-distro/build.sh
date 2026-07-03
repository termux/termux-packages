TERMUX_PKG_HOMEPAGE=https://github.com/termux/proot-distro
TERMUX_PKG_DESCRIPTION="Termux official utility for managing proot'ed Linux distributions"
TERMUX_PKG_LICENSE="GPL-3.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="5.4.0"
TERMUX_PKG_REVISION=1
TERMUX_PKG_SRCURL="https://github.com/termux/proot-distro/archive/refs/tags/v${TERMUX_PKG_VERSION}.tar.gz"
TERMUX_PKG_SHA256=53953ae3d6907ecc82affa2f73853965bf8985d59af3b11cae3acfb20b6b8b6b
# note for regular maintainers of proot-distro: since version 5.1.5, proot-distro
# has been detected by termux_step_create_python_debscripts as depending conditionally
# on pytest. since termux_step_create_python_debscripts cannot fully resolve conditional
# dependencies on its own, the resolution of this dependency is passed off to python-pip
# at install-time, which checks it to programmatically
# confirm that pytest is not required at runtime.
TERMUX_PKG_DEPENDS="proot (>= 5.1.107-71), python, python-pip"
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
