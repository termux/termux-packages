TERMUX_PKG_HOMEPAGE=https://github.com/sabamdarif/chroot-distro
TERMUX_PKG_DESCRIPTION="A lightweight chroot based utility for managing Linux containers"
TERMUX_PKG_LICENSE="GPL-3.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="2.8.2"
TERMUX_PKG_SRCURL="https://github.com/sabamdarif/chroot-distro/archive/refs/tags/v${TERMUX_PKG_VERSION}.tar.gz"
TERMUX_PKG_SHA256=f7ee31f71d1527beda25b60444fb82060ef4673bc7c0327c584b9b93dab70ca7
TERMUX_PKG_DEPENDS="python, python-pip"
TERMUX_PKG_SUGGESTS="bash-completion, zsh-completions"
TERMUX_PKG_BUILD_IN_SRC=true
TERMUX_PKG_PLATFORM_INDEPENDENT=true
TERMUX_PKG_AUTO_UPDATE=true

termux_step_pre_configure() {
	termux_setup_python_pip
}
