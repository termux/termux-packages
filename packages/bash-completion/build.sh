TERMUX_PKG_HOMEPAGE=https://github.com/scop/bash-completion
TERMUX_PKG_DESCRIPTION="Programmable completion for the bash shell"
TERMUX_PKG_LICENSE="GPL-2.0"
TERMUX_PKG_MAINTAINER="Joshua Kahn @TomJo2000"
TERMUX_PKG_VERSION="2.14.0"
TERMUX_PKG_SRCURL=https://github.com/scop/bash-completion/releases/download/${TERMUX_PKG_VERSION}/bash-completion-${TERMUX_PKG_VERSION}.tar.xz
TERMUX_PKG_SHA256=5c7494f968280832d6adb5aa19f745a56f1a79df311e59338c5efa6f7285e168
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_DEPENDS="bash"
TERMUX_PKG_PLATFORM_INDEPENDENT=true
TERMUX_PKG_RM_AFTER_INSTALL="
share/bash-completion/completions/makepkg
"
