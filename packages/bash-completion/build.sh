TERMUX_PKG_HOMEPAGE=https://github.com/scop/bash-completion
TERMUX_PKG_DESCRIPTION="Programmable completion for the bash shell"
TERMUX_PKG_LICENSE="GPL-2.0"
TERMUX_PKG_MAINTAINER="Joshua Kahn @TomJo2000"
TERMUX_PKG_VERSION="2.13.0"
TERMUX_PKG_SRCURL=https://github.com/scop/bash-completion/releases/download/${TERMUX_PKG_VERSION}/bash-completion-${TERMUX_PKG_VERSION}.tar.xz
TERMUX_PKG_SHA256=c5f99a39e40f0d154c03ff15438e87ece1f5ac666336a4459899e2ff4bedf3d1
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_DEPENDS="bash"
TERMUX_PKG_PLATFORM_INDEPENDENT=true
TERMUX_PKG_RM_AFTER_INSTALL="
share/bash-completion/completions/makepkg
"
